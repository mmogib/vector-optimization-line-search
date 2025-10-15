function [alpha, info] = linesearch_qwolfe_unified(~, ~, x, dvec, opts)
% linesearch_qwolfe_unified  Unified Quadratic-Wolfe line search (any m).
%   [alpha, info] = linesearch_qwolfe_unified(~, ~, x, dvec, opts)
%   - Evaluates F/G via problem_dispatcher using opts.name or opts.problemId.
%   - Supports optional epsiki curvature band (3‑obj 4x variants).
%   Inputs:
%     x, dvec  Current point and direction
%     opts     Struct with fields:
%                name|problemId, m, r|r1..rM, params
%                rho (1e-4), sigma (0.1), delta (1.1)
%                alphainit, alphamax (1e2), epsiki (optional)
%   Outputs:
%     alpha    Step length
%     info     Struct with fields: name, nf, ng, epsiki
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 4, error('linesearch_qwolfe_unified:NotEnoughInputs','Require x and dvec'); end
if nargin < 5 || (numel(opts)==0), opts = struct(); end

rho      = getfielddef(opts,'rho',1e-4);
sigma    = getfielddef(opts,'sigma',0.1);
delta    = getfielddef(opts,'delta',1.1);
alphamax = getfielddef(opts,'alphamax',1e2);
alphak   = getfielddef(opts,'alphainit', min(1, alphamax/2));
epsiki   = getfielddef(opts,'epsiki', []);

rhoba   = min(1.1*rho, 0.75*rho+0.25*sigma);
sigmaba = max(0.9*sigma, 0.25*rho+0.75*sigma);

% Problem key and params
if isfield(opts,'name') && ~(numel(opts.name)==0)
    key = opts.name;
elseif isfield(opts,'problemId')
    key = opts.problemId;
else
    error('linesearch_qwolfe_unified:BadProblem','Provide opts.name or opts.problemId');
end
params = getfielddef(opts,'params', struct());

% Weights r
if isfield(opts,'r') && ~(numel(opts.r)==0)
    r = opts.r(:)';
else
    r = collect_r(opts);
end

[Ffun, Gfun] = problem_dispatcher(key, getfielddef(opts,'m',[]), params);

alphakmin = 1e-15; nf = 0; ng = 0; s = 0; smax = 100;
while s < smax
    % Evals at x, x+alphak d, x+alphamax d
    Fk = Ffun(x); nf = nf + 1;
    Gk = Gfun(x); ng = ng + 1;
    Gdk = weighted_dir(Gk, dvec, r);
    phi0 = max(Gdk); % max weighted directional derivative

    Fak = Ffun(x + alphak*dvec); nf = nf + 1;
    Gak = Gfun(x + alphak*dvec); ng = ng + 1;
    Gdak = weighted_dir(Gak, dvec, r);
    phi_a = max(Gdak);

    Famax = Ffun(x + alphamax*dvec); nf = nf + 1;
    Gamax = Gfun(x + alphamax*dvec); ng = ng + 1;
    Gdamax = weighted_dir(Gamax, dvec, r);

    % Acceptance
    armijo_rhs = alphak * rho * phi0;
    armijo_all = all(r(:)'.*Fak(1:numel(r))' <= r(:)'.*Fk(1:numel(r))' + armijo_rhs);
    if (numel(epsiki)==0)
        curvature_ok = abs(phi_a) <= -sigma * phi0;
    else
        curvature_ok = (sigma*phi0 <= phi_a) && (phi_a <= epsiki);
    end
    if armijo_all && curvature_ok
        break;
    end

    armijo_rhs_amax = alphamax * rho * phi0;
    armijo_all_amax = all(r(:)'.*Famax(1:numel(r))' <= r(:)'.*Fk(1:numel(r))' + armijo_rhs_amax);
    curvature_amax_ok = all(Gdamax(1:numel(r)) < sigma*phi0);
    if armijo_all_amax && curvature_amax_ok
        alphak = alphamax; break;
    end

    % Identify first violating objective index
    mcur = numel(Fk);
    vio_idx = 0;
    for i = 1:mcur
        armijo_i = r_at(r,i)*Fak(i) <= r_at(r,i)*Fk(i) + armijo_rhs;
        if (numel(epsiki)==0)
            grad_i = r_at(r,i)*(Gak{i}'*dvec) <= -sigma*phi0;
        else
            grad_i = r_at(r,i)*(Gak{i}'*dvec) <= epsiki;
        end
        if ~(armijo_i && grad_i)
            vio_idx = i; break;
        end
    end

    if vio_idx > 0
        % Zoom via unified DWOLFE anchored at violating objective
        ls2 = struct('alphamax',alphamax,'sigmaba',sigmaba,'rhoba',rhoba,'m',mcur,...
                     'params',params,'r',r);
        if ~(numel(epsiki)==0), ls2.epsiki = epsiki; end
        if ischar(key) || isstring(key), ls2.name = key; else, ls2.problemId = key; end
        ls2.anchor = vio_idx;
        [alphak, info2] = linesearch_dwolfe([], [], x, dvec, ls2);
        nf = nf + getfielddef(info2,'nf',0); ng = ng + getfielddef(info2,'ng',0);
        break;
    else
        alphak = (min(delta*alphak, alphamax) + alphamax) / 2;
    end

    s = s + 1;
    if alphak <= alphakmin, alphak = alphakmin; break; end
end

alpha = alphak;
info = struct('name','qwolfe','nf',nf,'ng',ng,'epsiki',epsiki);

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

function r = collect_r(opts)
names = fieldnames(opts);
rmap = containers.Map('KeyType','double','ValueType','double');
for k = 1:numel(names)
    nm = names{k}; tok = regexp(nm, '^r(\d+)$', 'tokens');
    if ~(numel(tok)==0)
        idx = str2double(tok{1}{1}); rmap(idx) = opts.(nm);
    end
end
if rmap.Count == 0
    r = [];
else
    keys = sort(cell2mat(rmap.keys)); r = zeros(1, keys(end));
    for i = keys, r(i) = rmap(i); end
end
end

function Gd = weighted_dir(Gcell, dvec, r)
m = numel(Gcell); Gd = zeros(1,m);
for i = 1:m
    Gd(i) = r_at(r,i) * (Gcell{i}' * dvec);
end
end

function val = r_at(r, idx)
if (numel(r)==0) || numel(r) < idx, val = 1; else, val = r(idx); end
end
