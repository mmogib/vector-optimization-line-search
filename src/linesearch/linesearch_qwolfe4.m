function [alpha, info] = linesearch_qwolfe4(f, g, x, dvec, opts)
% linesearch_qwolfe4  Wrapper around legacy qwolfe4.m (3 objectives, epsiki).

if nargin < 4
    error('linesearch_qwolfe4:NotEnoughInputs', 'Require f,g,x,dvec.');
end
if nargin < 5 || isempty(opts), opts = struct(); end
alphamax = getfielddef(opts, 'alphamax', 1e2);
alphainit = getfielddef(opts, 'alphainit', min(1, alphamax/2));
epsiki   = getfielddef(opts, 'epsiki', 1e2);
probId   = getfielddef(opts, 'problemId', 1);
r1       = getfielddef(opts, 'r1', 1);
r2       = getfielddef(opts, 'r2', 1);
r3       = getfielddef(opts, 'r3', 1);

nf = 0; ng = 0;
[alpha, nf, ng] = qwolfe4(x, dvec, alphainit, epsiki, alphamax, nf, ng, probId, r1, r2, r3);
info = struct('name','qwolfe4','nf',nf,'ng',ng,'epsiki',epsiki);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end

