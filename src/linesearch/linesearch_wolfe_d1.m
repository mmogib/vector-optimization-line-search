function [alpha, info] = linesearch_wolfe_d1(f, g, x, dvec, opts)
% linesearch_wolfe_d1  Wrapper around legacy dwolfe1.m with unified API.
%   [alpha, info] = linesearch_wolfe_d1(f, g, x, dvec, opts)
%   Ignores f,g handles; relies on legacy f1/g1/g2 functions on path.
%   Options (opts) fields used (with defaults):
%     alphamax (1e10), sigmaba (0.9), rhoba (1e-4),
%     problemId (1), r1 (1), r2 (1)

if nargin < 4
    error('linesearch_wolfe_d1:NotEnoughInputs', 'Require f,g,x,dvec.');
end

if nargin < 5 || isempty(opts), opts = struct(); end
alphamax = getfielddef(opts, 'alphamax', 1e10);
sigmaba  = getfielddef(opts, 'sigmaba', 0.9);
rhoba    = getfielddef(opts, 'rhoba', 1e-4);
probId   = getfielddef(opts, 'problemId', 1);
r1       = getfielddef(opts, 'r1', 1);
r2       = getfielddef(opts, 'r2', 1);

nf = 0; ng = 0;
% Use two-objective variant explicitly to avoid name collisions
[alpha, nf, ng] = dwolfe1_2obj(x, dvec, alphamax, sigmaba, rhoba, nf, ng, probId, r1, r2);
info = struct('name','dwolfe1','nf',nf,'ng',ng);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end
