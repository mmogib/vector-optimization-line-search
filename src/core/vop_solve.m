function [x, Fvals, info] = vop_solve(problem, opts)
% vop_solve  Unified line-search solver for Vector Optimization Problems (VOP).
%   [x, Fvals, info] = vop_solve(problem, opts)
%
%   Inputs
%     problem.x0        Initial point (column vector)
%     problem.problemId Integer dataset/problem ID (matches legacy f1/f2/f3,g1/g2/g3)
%     problem.m         Number of objectives (2 or 3)
%     problem.r         Optional scaling weights [r1 r2 (r3)]
%
%   Options (opts)
%     direction   one of: 'hz','hzn','sd','prp' (default: 'hz' for m=2, 'sd' for m=3)
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
%   - HZ/HZN directions currently support m=2 via hz_subproblem.

% Validate inputs
if nargin < 1 || ~isstruct(problem) || ~isfield(problem,'x0') || ~isfield(problem,'problemId')
    error('vop_solve:BadProblem', 'Provide problem.x0 and problem.problemId');
end
if nargin < 2, opts = struct(); end

x = problem.x0(:);
dId = problem.problemId;
if ~isfield(problem,'m')
    problem.m = 2; % default
end
m = problem.m;

% Unified problem API for this problemId
[Ffun, Gfun] = problem_dispatcher(dId, m);
maxIter  = getfielddef(opts,'maxIter',500);
tol      = getfielddef(opts,'tol',1e-8);
alphamax = getfielddef(opts,'alphamax',1e10);
verbose  = getfielddef(opts,'verbose',0);

% Choose defaults by m
if m == 2
    % Recommended defaults from sweep: sd + qwolfe
    directionName = getfielddef(opts,'direction','sd');
    linesearchName = getfielddef(opts,'linesearch','qwolfe');
elseif m == 3
    directionName = getfielddef(opts,'direction','sd'); % HZ/HZN (m=3) not implemented yet
    linesearchName = getfielddef(opts,'linesearch','dwolfe3');
else
    error('vop_solve:UnsupportedM','Only m=2 or m=3 supported');
end

% Compute or set scaling r
if isfield(problem,'r') && ~isempty(problem.r)
    r = problem.r(:)';
else
    r = compute_scaling(x, dId, m);
end

% Initial evals
[Fvals, grads] = eval_FG(x);
nf = m; ng = m;

% Initialize
history = struct('grad_prev',[],'d_prev',[],'v_prev',[]);
alphas = zeros(maxIter,1);
reason = 'maxIter';

% HZ/HZN-specific state
useHZ = (m == 2) && (strcmpi(directionName,'hz') || strcmpi(directionName,'hzn'));
if useHZ
    % Initial v and fxkvk at x
    [vk, fxkvk, qpout] = hz_subproblem(x, dId, r(1), r(2));
    if norm(vk) < tol
        % Fallback to steepest descent on weighted gradient
        gsum0 = grads{1}*r(1); for i=2:m, gsum0 = gsum0 + grads{i}*r(i); end
        dvec = -gsum0;
    else
        dvec = vk;
    end
    history.v_prev = vk;
else
    dvec = [];
end

for k = 1:maxIter
    % Direction
    if useHZ
        if k > 1 && isfield(history,'d_next') && ~isempty(history.d_next)
            dvec = history.d_next; % carry over adaptive update
        else
            % Fallback to current v
            dvec = history.v_prev;
        end
        dstate = struct('name',directionName);
    else
        switch lower(directionName)
            case 'sd'
                % Use weighted sum gradient for direction
                gsum = grads{1}*r(1);
                for i=2:m, gsum = gsum + grads{i}*r(i); end
                [dvec, dstate] = direction_sd(x, gsum, history, opts);
            case 'prp'
                gsum = grads{1}*r(1);
                for i=2:m, gsum = gsum + grads{i}*r(i); end
                [dvec, dstate] = direction_prp(x, gsum, history, opts);
            otherwise
                error('vop_solve:BadDirection','Unknown/non-HZ direction %s', directionName);
        end
    end

    if norm(dvec) < tol
        reason = 'small_direction';
        alphas = alphas(1:k-1);
        break
    end

    % Linesearch selection
    lsopts = struct('alphamax',alphamax,'problemId',dId);
    for i=1:m, lsopts.(sprintf('r%d',i)) = r(i); end
    % Pass-through Wolfe constants if provided in opts
    if isfield(opts,'rhoba') && ~isempty(opts.rhoba), lsopts.rhoba = opts.rhoba; end
    if isfield(opts,'sigmaba') && ~isempty(opts.sigmaba), lsopts.sigmaba = opts.sigmaba; end

    switch lower(linesearchName)
        case 'dwolfe1'
            [alpha, lsinfo] = linesearch_wolfe_d1([], [], x, dvec, lsopts);
        case 'dwolfe2'
            [alpha, lsinfo] = linesearch_wolfe_d2([], [], x, dvec, lsopts);
        case 'qwolfe'
            [alpha, lsinfo] = linesearch_qwolfe([], [], x, dvec, lsopts);
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
    nf = nf + getfielddef(lsinfo,'nf',0);
    ng = ng + getfielddef(lsinfo,'ng',0);

    % Step
    x_new = x + alpha * dvec;

    % Update evals, history
    history.d_prev = dvec;
    history.grad_prev = grads{1}*r(1);
    for i=2:m, history.grad_prev = history.grad_prev + grads{i}*r(i); end

    x = x_new;
    [Fvals, grads] = eval_FG(x);
    nf = nf + m; ng = ng + m;

    % HZ/HZN adaptive direction update for next iteration
    if useHZ
        % Constants
        mu  = getfielddef(opts,'hz_mu',1);
        c   = getfielddef(opts,'hz_c',0.4);
        ita = getfielddef(opts,'hz_ita',1e-2);

        % Values at previous x
        vk_prev    = history.v_prev;
        fxkdk      = NaN; % will recompute below properly
        % Recompute grads at previous x explicitly (grads_prev)
        [~, grads_prev] = eval_FG(x - alpha*dvec);
        fxkdk = max([r(1)*grads_prev{1}'*dvec, r(2)*grads_prev{2}'*dvec]);

        % v at new x
        [vki, fxkivki, ~] = hz_subproblem(x, dId, r(1), r(2));

        % Terms for betaki
        fxkvki = max([r(1)*grads_prev{1}'*vki, r(2)*grads_prev{2}'*vki]);
        p = -fxkivki + fxkvki;
        fxkidk = max([r(1)*grads{1}'*dvec, r(2)*grads{2}'*dvec]);
        fxkivk = max([r(1)*grads{1}'*vk_prev, r(2)*grads{2}'*vk_prev]);
        q = fxkivk - fxkvk;
        denom = fxkidk - fxkdk;
        if ~isfinite(denom) || abs(denom) < 1e-14
            betakiHZ = 0;
        else
            betakiHZ = (1/denom) * (p - mu*fxkidk*((p+q)/denom));
        end
        itak = -1/(norm(dvec) * min(ita, norm(vk_prev)) + eps);
        betaki = max(betakiHZ, itak);
        d_next = vki + betaki * dvec;

        % Acceptance test and adjustment
        fxkidki = max([r(1)*grads{1}'*d_next, r(2)*grads{2}'*d_next]);
        if fxkidki > c * fxkivki
            if betaki < 0
                h = max([r(1)*grads{1}'*(-dvec), r(2)*grads{2}'*(-dvec)]);
                if h > 0
                    betaki = (1 - c) * fxkivki / h;
                else
                    betaki = 0;
                end
                d_next = vki + betaki * dvec;
            end
        end

        % Save for next iteration
        history.v_prev = vki;
        history.d_next = d_next;
        fxkvk = fxkivki;
    end

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

info = struct('iters', numel(alphas), 'alphas', alphas, 'nf', nf, 'ng', ng, 'reason', reason, 'direction', directionName, 'linesearch', linesearchName);
if exist('Xhist','var')
    info.X = Xhist; info.Fhist = Fhist;
end

end

function r = compute_scaling(x, dId, m)
% Compute r_i = 1 / max(1, ||g_i||_inf) at x via dispatcher
[~, Gfun_loc] = problem_dispatcher(dId, m);
gs = Gfun_loc(x);
r = zeros(1, numel(gs));
for i=1:numel(gs)
    r(i) = 1 / max(1, norm(gs{i}, inf));
end
if numel(r) < m
    r(numel(r)+1:m) = 1;
end
end

function [Fvals, grads] = eval_FG(x)
% Evaluate objective values and gradients via unified API (raw, unscaled)
Fvals = Ffun(x);
grads = Gfun(x);
end

function v = getfielddef(s, name, default)
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end
