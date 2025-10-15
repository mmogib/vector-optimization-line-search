function [alpha, info] = linesearch_qwolfe4(f, g, x, dvec, opts)
% linesearch_qwolfe4  Unified Quadratic‑Wolfe wrapper with epsiki (m=3).
%   [alpha, info] = linesearch_qwolfe4(f, g, x, dvec, opts)
%   Delegates to linesearch_qwolfe_unified with epsiki and m defaulting to 3.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.m = getfielddef(opts,'m',3);
opts.epsiki = getfielddef(opts,'epsiki', 1e2);
[alpha, info] = linesearch_qwolfe_unified(f, g, x, dvec, opts);
info.name = 'qwolfe4';
end
