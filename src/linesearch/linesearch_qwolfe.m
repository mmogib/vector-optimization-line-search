function [alpha, info] = linesearch_qwolfe(f, g, x, dvec, opts)
% linesearch_qwolfe  Unified Quadratic‑Wolfe wrapper (m‑agnostic).
%   [alpha, info] = linesearch_qwolfe(f, g, x, dvec, opts)
%   Delegates to linesearch_qwolfe_unified. See that function for opts.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
[alpha, info] = linesearch_qwolfe_unified(f, g, x, dvec, opts);
info.name = 'qwolfe';
end
