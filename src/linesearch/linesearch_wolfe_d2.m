function [alpha, info] = linesearch_wolfe_d2(f, g, x, dvec, opts)
% linesearch_wolfe_d2  Strong Wolfe wrapper anchored at objective 2.
%   [alpha, info] = linesearch_wolfe_d2(f, g, x, dvec, opts)
%   Delegates to linesearch_dwolfe with opts.anchor = 2.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.anchor = 2;
[alpha, info] = linesearch_dwolfe(f, g, x, dvec, opts);
info.name = 'dwolfe2';
end
