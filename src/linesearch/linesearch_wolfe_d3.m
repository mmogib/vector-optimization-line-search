function [alpha, info] = linesearch_wolfe_d3(f, g, x, dvec, opts)
% linesearch_wolfe_d3  Wrapper around legacy dwolfe3.m (3 objectives).

if nargin < 4
    error('linesearch_wolfe_d3:NotEnoughInputs', 'Require f,g,x,dvec.');
end
if nargin < 5 || isempty(opts), opts = struct(); end
alphamax = getfielddef(opts, 'alphamax', 1e10);
sigmaba  = getfielddef(opts, 'sigmaba', 0.9);
rhoba    = getfielddef(opts, 'rhoba', 1e-4);
probId   = getfielddef(opts, 'problemId', 1);
r1       = getfielddef(opts, 'r1', 1);
r2       = getfielddef(opts, 'r2', 1);
r3       = getfielddef(opts, 'r3', 1);

nf = 0; ng = 0;
[alpha, nf, ng] = dwolfe3(x, dvec, alphamax, sigmaba, rhoba, nf, ng, probId, r1, r2, r3);
info = struct('name','dwolfe3','nf',nf,'ng',ng);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end

