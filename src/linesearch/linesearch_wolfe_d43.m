function [alpha, info] = linesearch_wolfe_d43(f, g, x, dvec, opts)
% linesearch_wolfe_d43  Wrapper around legacy dwolfe43.m (3 objectives, epsiki).

if nargin < 5 || isempty(opts), opts = struct(); end
alphamax = getfielddef(opts, 'alphamax', 1e10);
epsiki   = getfielddef(opts, 'epsiki', 1e2);
sigmaba  = getfielddef(opts, 'sigmaba', 0.9);
rhoba    = getfielddef(opts, 'rhoba', 1e-4);
probId   = getfielddef(opts, 'problemId', 1);
r1       = getfielddef(opts, 'r1', 1);
r2       = getfielddef(opts, 'r2', 1);
r3       = getfielddef(opts, 'r3', 1);

nf = 0; ng = 0;
[alpha, nf, ng] = dwolfe43(x, dvec, alphamax, epsiki, sigmaba, rhoba, nf, ng, probId, r1, r2, r3);
info = struct('name','dwolfe43','nf',nf,'ng',ng,'epsiki',epsiki);
end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end

