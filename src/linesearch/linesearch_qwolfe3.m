function [alpha, info] = linesearch_qwolfe3(f, g, x, dvec, opts)
% linesearch_qwolfe3  Unified Quadratic‑Wolfe wrapper (m=3).
%   [alpha, info] = linesearch_qwolfe3(f, g, x, dvec, opts)
%   Delegates to linesearch_qwolfe_unified with m=3.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.m = 3;
[alpha, info] = linesearch_qwolfe_unified(f, g, x, dvec, opts);
info.name = 'qwolfe3';
end
