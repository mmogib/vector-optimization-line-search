function [x, Fvals, info] = vop_solve(problem, opts)
% vop_solve  Unified line-search solver for Vector Optimization Problems (VOP).
%   Refactored by: Dr. Mohammed Alshahrani
%   [x, Fvals, info] = vop_solve(problem, opts)
%
%   Inputs
%     problem.x0        Initial point (column vector)
%     problem.problemId Integer dataset/problem ID (matches legacy f1/f2/f3,g1/g2/g3)
%     problem.m         Number of objectives (2 or 3)
%     problem.r         Optional scaling weights [r1 r2 (r3)]
%
%   Options (opts)
%     direction   one of: 'hz','sd','prp' (default: 'sd' for m=2, 'sd' for m=3)
%     linesearch  for m=2: 'dwolfe1','dwolfe2','qwolfe' (default: 'dwolfe1')
%                 for m=3: 'dwolfe3','dwolfe41','dwolfe42','dwolfe43','qwolfe3','qwolfe4' (default: 'dwolfe3')
%     maxIter     max iterations (default 500)
%     tol         stopping tolerance on step norm (default 1e-8)
%     alphamax    maximum step (default 1e10)
%     verbose     0/1 for basic progress (default 0)
%
%   Output
%     x       final point
%     Fvals   objective values at x (vector of length m)
%     info    struct with fields: iters, alphas, nf, ng, reason
%
%   Notes
%   - Relies on legacy f1/f2/f3 and g1/g2/g3 functions on path.
%   - HZ direction currently supports m=2 via hz_subproblem.

% Validate inputs
if nargin < 1 || ~isstruct(problem) || ~isfield(problem,'x0')
    error('vop_solve:BadProblem', 'Provide problem.x0 and a problem identifier (name or id).');
end
if nargin < 2, opts = struct(); end

x = problem.x0(:);
% Accept either problem.name (preferred) or legacy problemId
if isfield(problem,'name') && ~(numel(problem.name)==0)
    dId = problem.name; % name key, e.g., 'bk1','vu1','sp1'
elseif isfield(problem,'problemId')
    dId = problem.problemId;
else
    error('vop_solve:BadProblem','Provide problem.name or problem.problemId');
end
if ~isfield(problem,'m')
    problem.m = 2; % default
end
m = problem.m;

% Unified problem API for this problemId
params = struct();
if isfield(problem,'params') && ~(numel(problem.params)==0)
    params = problem.params;
end
[Ffun, Gfun] = problem_dispatcher(dId, m, params);
maxIter  = getfielddef(opts,'maxIter',500);
tol      = getfielddef(opts,'tol',1e-8);
alphamax = getfielddef(opts,'alphamax',1e10);
verbose  = getfielddef(opts,'verbose',0);
gradTol  = getfielddef(opts,'gradTol',1e-6);
recEvery = getfielddef(opts,'recordIntermediateEvery',0);

% Choose defaults by m
if m == 2
    % Recommended defaults from sweep: sd + qwolfe
    directionName = getfielddef(opts,'direction','sd');
    linesearchName = getfielddef(opts,'linesearch','qwolfe');
elseif m == 3
    directionName = getfielddef(opts,'direction','sd'); % HZ (m=3) not implemented yet
    linesearchName = getfielddef(opts,'linesearch','dwolfe3');
else
    error('vop_solve:UnsupportedM','Only m=2 or m=3 supported');
end


% Compute or set scaling r
if isfield(problem,'r') && ~(numel(problem.r)==0)
    r = problem.r(:)';
else
    r = compute_scaling(x, dId, m, params);
end

% Initial evals
[Fvals, grads] = eval_FG_local(x, Ffun, Gfun);
% Count one objective and one gradient call as m evaluations each
nf = m; ng = m;

% Initialize
history = struct('grad_prev',[],'d_prev',[],'v_prev',[]);
alphas = zeros(maxIter,1);
reason = 'maxIter';
F_inter = [];
ls_iters_total = 0; dir_iters_total = 0;

% Initialize direction
dvec = [];

for k = 1:maxIter
    % Direction
    switch lower(directionName)
        case 'sd'
            gsum = grads{1}*r(1);
            for i=2:m, gsum = gsum + grads{i}*r(i); end
            [dvec, dstate] = direction_sd(x, gsum, history, opts);
        case 'prp'
            gsum = grads{1}*r(1);
            for i=2:m, gsum = gsum + grads{i}*r(i); end
            [dvec, dstate] = direction_prp(x, gsum, history, opts);
        case 'hz'
            dopts = opts; % pass-through HZ params
            if ischar(dId) || isstring(dId), dopts.name = dId; else, dopts.problemId = dId; end
            dopts.r1 = r(1); dopts.r2 = r(2); dopts.params = params;
            [dvec, dstate] = direction_hz(x, [], history, dopts);
        otherwise
            error('vop_solve:BadDirection','Unknown direction %s', directionName);
    end

    % Accumulate internal iterations and evals from direction (if any)
    dir_iters_total = dir_iters_total + getfielddef(dstate,'iters',0);
    nf = nf + getfielddef(dstate,'nf',0);
    ng = ng + getfielddef(dstate,'ng',0);

    if norm(dvec) < tol
        reason = 'small_direction';
        alphas = alphas(1:k-1);
        break
    end

    % Linesearch selection
    lsopts = struct('alphamax',alphamax,'problemId',dId,'params',params,'m',m);
    for i=1:m, lsopts.(sprintf('r%d',i)) = r(i); end
    % Pass-through Wolfe constants if provided in opts
    if isfield(opts,'rhoba') && ~(numel(opts.rhoba)==0), lsopts.rhoba = opts.rhoba; end
    if isfield(opts,'sigmaba') && ~(numel(opts.sigmaba)==0), lsopts.sigmaba = opts.sigmaba; end

    switch lower(linesearchName)
        case 'dwolfe1'
            [alpha, lsinfo] = linesearch_wolfe_d1([], [], x, dvec, lsopts);
        case 'dwolfe2'
            [alpha, lsinfo] = linesearch_wolfe_d2([], [], x, dvec, lsopts);
        case 'qwolfe'
            [alpha, lsinfo] = linesearch_qwolfe([], [], x, dvec, lsopts);
        case 'dwolfe' % unified strong Wolfe, use opts.anchor or default 1
            if isfield(opts,'anchor') && ~(numel(opts.anchor)==0), lsopts.anchor = opts.anchor; end
            [alpha, lsinfo] = linesearch_dwolfe([], [], x, dvec, lsopts);
        case 'dwolfe3'
            [alpha, lsinfo] = linesearch_wolfe_d3([], [], x, dvec, lsopts);
        case 'dwolfe41'
            lsopts.epsiki = getfielddef(opts,'epsiki',1e2);
            [alpha, lsinfo] = linesearch_wolfe_d41([], [], x, dvec, lsopts);
        case 'dwolfe42'
            lsopts.epsiki = getfielddef(opts,'epsiki',1e2);
            [alpha, lsinfo] = linesearch_wolfe_d42([], [], x, dvec, lsopts);
        case 'dwolfe43'
            lsopts.epsiki = getfielddef(opts,'epsiki',1e2);
            [alpha, lsinfo] = linesearch_wolfe_d43([], [], x, dvec, lsopts);
        case 'qwolfe3'
            [alpha, lsinfo] = linesearch_qwolfe3([], [], x, dvec, lsopts);
        case 'qwolfe4'
            lsopts.epsiki = getfielddef(opts,'epsiki',1e2);
            [alpha, lsinfo] = linesearch_qwolfe4([], [], x, dvec, lsopts);
        otherwise
            error('vop_solve:BadLinesearch','Unknown linesearch %s', linesearchName);
    end

    if ~(isfinite(alpha)) || alpha <= 0
        reason = 'no_progress';
        alphas = alphas(1:k-1);
        break
    end

    alphas(k) = alpha;
    % Accumulate line-search internal iterations and evals
    ls_iters_total = ls_iters_total + getfielddef(lsinfo,'iters',0);
    nf = nf + getfielddef(lsinfo,'nf',0);
    ng = ng + getfielddef(lsinfo,'ng',0);

    % Step
    x_new = x + alpha * dvec;

    % Update evals, history
    % Update history from state (for HZ), or maintain SD/PRP fields
    if isfield(dstate,'history')
        history = dstate.history;
    else
        history.d_prev = dvec;
        history.grad_prev = grads{1}*r(1);
        for i=2:m, history.grad_prev = history.grad_prev + grads{i}*r(i); end
    end

    x = x_new;
    [Fvals, grads] = eval_FG_local(x, Ffun, Gfun);
    nf = nf + m; ng = ng + m;

    % Optionally collect intermediate objective vectors every K iterations
    if recEvery > 0 && mod(k, recEvery) == 0
        if (numel(F_inter) == 0)
            F_inter = Fvals;
        else
            F_inter(:, end+1) = Fvals; %#ok<AGROW>
        end
    end

    % Gradient-based stopping (weighted sum infinity-norm)
    gsum_now = grads{1}*r(1);
    for i=2:m, gsum_now = gsum_now + grads{i}*r(i); end
    if norm(gsum_now, inf) < gradTol
        reason = 'small_gradient';
        alphas = alphas(1:k);
        break
    end

    % HZ adaptation handled inside direction_hz

    % Simple stopping by step size
    if norm(alpha*dvec) < tol
        reason = 'small_step';
        alphas = alphas(1:k);
        break
    end
    if k == maxIter
        alphas = alphas(1:k);
    end
    if getfielddef(opts,'record',false)
        if k == 1
            Xhist = x; Fhist = Fvals;
        else
            Xhist(:,end+1) = x; %#ok<AGROW>
            Fhist(:,end+1) = Fvals; %#ok<AGROW>
        end
    end
    if verbose
        fprintf('it=%d, alpha=%.3e, ||d||=%.3e\n', k, alpha, norm(dvec));
    end
end

info = struct('iters', numel(alphas), 'alphas', alphas, 'nf', nf, 'ng', ng, ...
              'ls_internal_iters', ls_iters_total, 'dir_internal_iters', dir_iters_total, ...
              'reason', reason, 'direction', directionName, 'linesearch', linesearchName);
if ~(numel(F_inter)==0), info.intermediateF = F_inter; end
if exist('Xhist','var')
    info.X = Xhist; info.Fhist = Fhist;
end

end

function r = compute_scaling(x, dId, m, params)
% Compute r_i = 1 / max(1, ||g_i||_inf) at x via dispatcher
[~, Gfun_loc] = problem_dispatcher(dId, m, params);
gs = Gfun_loc(x);
r = zeros(1, numel(gs));
for i=1:numel(gs)
    r(i) = 1 / max(1, norm(gs{i}, inf));
end
if numel(r) < m
    r(numel(r)+1:m) = 1;
end
end

function [Fvals, grads] = eval_FG_local(x, Ffun, Gfun)
% Evaluate objective values and gradients via unified API (raw, unscaled)
Fvals = Ffun(x);
grads = Gfun(x);
end

function v = getfielddef(s, name, default)
if isstruct(s) && isfield(s, name)
    val = s.(name);
    if ~(numel(val) == 0)
        v = val; return
    end
end
v = default;
end
