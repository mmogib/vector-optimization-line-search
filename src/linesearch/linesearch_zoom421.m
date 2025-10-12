function [alpha, info] = linesearch_zoom421(f, g, x, dvec, opts)
% linesearch_zoom421  Wrapper for legacy zoom421.m (3 objectives, epsiki).

if nargin < 5 || isempty(opts), error('linesearch_zoom421:OptsRequired','opts with alpha0/alpha1 required'); end
alpha0  = opts.alpha0; alpha1 = opts.alpha1;
epsiki  = getfielddef(opts,'epsiki',1e2);
sigmaba = getfielddef(opts,'sigmaba',0.9);
rhoba   = getfielddef(opts,'rhoba',1e-4);
probId  = getfielddef(opts,'problemId',1);
r1      = getfielddef(opts,'r1',1);
r2      = getfielddef(opts,'r2',1);
r3      = getfielddef(opts,'r3',1);

nf = 0; ng = 0;
[alpha, nf, ng] = zoom421(alpha0, alpha1, dvec, x, epsiki, sigmaba, rhoba, nf, ng, probId, r1, r2, r3);
info = struct('name','zoom421','nf',nf,'ng',ng,'alpha0',alpha0,'alpha1',alpha1,'epsiki',epsiki);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end

