function [alpha, info] = linesearch_dwolfe(~, ~, x, dvec, opts)
% linesearch_dwolfe  Unified strong Wolfe line search for VOP (any m).
%   [alpha, info] = linesearch_dwolfe(~, ~, x, dvec, opts)
%   - Evaluates F/G via problem_dispatcher using opts.name or opts.problemId.
%   - Supports arbitrary dimension and objective count; anchors on one objective.
%   Inputs:
%     x      Current point (n x 1)
%     dvec   Search direction (n x 1)
%     opts   Struct with fields:
%              name|problemId  Problem key (preferred: opts.name)
%              m               Objective count (optional)
%              r|r1..rM        Weights (row vector or individual fields)
%              alphamax        Max step (default 1e10)
%              rhoba,sigmaba   Wolfe constants (defaults 1e-4, 0.9)
%              anchor          Objective index to anchor (default 1)
%              params          Extra problem params (optional)
%              epsiki          Optional curvature upper bound (3‑obj variants)
%   Outputs:
%     alpha  Step length satisfying strong Wolfe (or epsiki) conditions
%     info   Struct with fields: name, nf, ng, anchor
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 4
    error('linesearch_dwolfe:NotEnoughInputs','Require x and dvec');
end
if nargin < 5 || (numel(opts)==0), opts = struct(); end

alphamax = getfielddef(opts, 'alphamax', 1e10);
sigmaba  = getfielddef(opts, 'sigmaba', 0.9);
rhoba    = getfielddef(opts, 'rhoba', 1e-4);
anchor   = getfielddef(opts, 'anchor', 1);

% Problem key and params
if isfield(opts,'name') && ~(numel(opts.name)==0)
    key = opts.name;
elseif isfield(opts,'problemId')
    key = opts.problemId;
else
    error('linesearch_dwolfe:BadProblem','Provide opts.name or opts.problemId');
end
params = getfielddef(opts, 'params', struct());
epsiki  = getfielddef(opts, 'epsiki', []);

% Build r vector from r1..rm if needed
if isfield(opts, 'r') && ~(numel(opts.r)==0)
    r = opts.r(:)';
else
    r = collect_r(opts);
end

[Ffun, Gfun] = problem_dispatcher(key, getfielddef(opts,'m',[]), params);

% Ensure anchor within m
Fk = Ffun(x); m = numel(Fk); anchor = max(1, min(anchor, m));

alpha0 = 0; alpha1 = alphamax/2; i = 1; imax = 40;
nf = 0; ng = 0;

while i < imax
    x_a1 = x + alpha1 * dvec;
    F_a1 = Ffun(x_a1); nf = nf + 1;
    F_k  = Ffun(x);    nf = nf + 1;
    G_k  = Gfun(x);    ng = ng + 1;
    phi0 = max_weighted_dir(G_k, dvec, r, m);
    armijo = r_at(r, anchor) * F_k(anchor) + alpha1 * rhoba * phi0;

    F_a0 = Ffun(x + alpha0*dvec); nf = nf + 1;
    if r_at(r, anchor) * F_a1(anchor) > armijo || (r_at(r, anchor) * F_a1(anchor) >= r_at(r, anchor) * F_a0(anchor) && i > 1)
        [alpha, nf2, ng2, zits] = zoom_anchor(alpha0, alpha1, x, dvec, anchor, sigmaba, rhoba, r, Ffun, Gfun, epsiki);
        nf = nf + nf2; ng = ng + ng2;
        break;
    end

    G_a1 = Gfun(x_a1); ng = ng + 1;
    if abs(r_at(r, anchor) * G_a1{anchor}' * dvec) <= -sigmaba * phi0
        alpha = alpha1; break
    end
    if r_at(r, anchor) * G_a1{anchor}' * dvec >= 0
        [alpha, nf2, ng2, zits] = zoom_anchor(alpha1, alpha0, x, dvec, anchor, sigmaba, rhoba, r, Ffun, Gfun, epsiki);
        nf = nf + nf2; ng = ng + ng2;
        break;
    end
    alpha1 = (alpha1 + alphamax)/2; i = i + 1;
end

% Fallback
if ~exist('alpha','var'), alpha = alpha1; end

% Internal iterations: outer bracket steps (i) plus zoom iterations (if any)
iters = i;
try, iters = iters + zits; catch, end

info = struct('name','dwolfe', 'nf', nf, 'ng', ng, 'iters', iters, 'anchor', anchor);

end

function [alphak, nf, ng, s] = zoom_anchor(alpha0, alpha1, x, dvec, anchor, sigmaba, rhoba, r, Ffun, Gfun, epsiki)
nf = 0; ng = 0;
s = 0; smax = 20;
while s < smax
    alphaj = (alpha0 + alpha1) / 2;
    xj = x + alphaj * dvec;
    Fj = Ffun(xj); Fk = Ffun(x); nf = nf + 2;
    Gk = Gfun(x); ng = ng + 1;
    phi0 = max_weighted_dir(Gk, dvec, r, numel(Fj));
    Fa0 = Ffun(x + alpha0*dvec); nf = nf + 1;
    if r_at(r, anchor) * Fj(anchor) > r_at(r, anchor) * Fk(anchor) + alphaj * rhoba * phi0 || r_at(r, anchor) * Fj(anchor) >= r_at(r, anchor) * Fa0(anchor)
        alpha1 = alphaj;
    else
        Gj = Gfun(xj); ng = ng + 1;
        gjd = r_at(r, anchor) * Gj{anchor}' * dvec;
        if ~(numel(epsiki)==0)
            if (gjd >= sigmaba * phi0) && (gjd <= epsiki)
                alphak = alphaj; return
            end
        else
            if abs(gjd) <= sigmaba * abs(phi0)
                alphak = alphaj; return
            end
        end
        if (gjd) * (alpha1 - alpha0) >= 0
            alpha1 = alpha0;
        end
        alpha0 = alphaj;
    end
    s = s + 1; if s == smax, alphak = alphaj; return; end
end
alphak = (alpha0 + alpha1)/2;
end

function val = r_at(r, idx)
if (numel(r)==0) || numel(r) < idx, val = 1; else, val = r(idx); end
end

function phi = max_weighted_dir(Gcell, dvec, r, m)
if nargin < 4, m = numel(Gcell); end
phi = -Inf;
for i = 1:m
    ri = r_at(r, i);
    gi = Gcell{i};
    phi = max(phi, ri * (gi' * dvec));
end
end

function r = collect_r(opts)
% Collect r1..rM from opts into a row vector
names = fieldnames(opts);
rmap = containers.Map('KeyType','double','ValueType','double');
for k = 1:numel(names)
    nm = names{k};
    tok = regexp(nm, '^r(\d+)$', 'tokens');
    if ~(numel(tok)==0)
        idx = str2double(tok{1}{1});
        rmap(idx) = opts.(nm);
    end
end
if rmap.Count == 0
    r = [];
else
    keys = sort(cell2mat(rmap.keys));
    r = zeros(1, keys(end));
    for i = keys
        r(i) = rmap(i);
    end
end
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
