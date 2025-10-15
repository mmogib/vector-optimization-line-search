function [alpha, info] = linesearch_wolfe_d41(f, g, x, dvec, opts)
% linesearch_wolfe_d41  DWOLFE with epsiki, anchored at objective 1.
%   [alpha, info] = linesearch_wolfe_d41(f, g, x, dvec, opts)
%   Delegates to linesearch_dwolfe with opts.anchor = 1 and opts.epsiki.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.anchor = 1;
opts.epsiki = getfielddef(opts,'epsiki',1e2);
[alpha, info] = linesearch_dwolfe(f, g, x, dvec, opts);
info.name = 'dwolfe41';
end
