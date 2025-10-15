function [alpha, info] = linesearch_wolfe_d3(f, g, x, dvec, opts)
% linesearch_wolfe_d3  Strong Wolfe wrapper anchored at objective 3.
%   [alpha, info] = linesearch_wolfe_d3(f, g, x, dvec, opts)
%   Delegates to linesearch_dwolfe with opts.anchor = 3.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.anchor = 3;
[alpha, info] = linesearch_dwolfe(f, g, x, dvec, opts);
info.name = 'dwolfe3';
end
