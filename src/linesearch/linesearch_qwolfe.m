function [alpha, info] = linesearch_qwolfe(f, g, x, dvec, opts)
% linesearch_qwolfe  Wrapper around legacy qwolfe.m with unified API.
%   [alpha, info] = linesearch_qwolfe(f, g, x, dvec, opts)
%   Ignores f,g handles; relies on legacy f1/g1/g2 on path.

if nargin < 4
    error('linesearch_qwolfe:NotEnoughInputs', 'Require f,g,x,dvec.');
end

if nargin < 5 || isempty(opts), opts = struct(); end
alphamax = getfielddef(opts, 'alphamax', 1e2);
alphainit = getfielddef(opts, 'alphainit', min(1, alphamax/2));
probId   = getfielddef(opts, 'problemId', 1);
r1       = getfielddef(opts, 'r1', 1);
r2       = getfielddef(opts, 'r2', 1);

nf = 0; ng = 0;
[alpha, nf, ng] = qwolfe(x, dvec, alphainit, alphamax, nf, ng, probId, r1, r2);
info = struct('name','qwolfe','nf',nf,'ng',ng);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end

