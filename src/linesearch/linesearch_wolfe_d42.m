function [alpha, info] = linesearch_wolfe_d42(f, g, x, dvec, opts)
% linesearch_wolfe_d42  DWOLFE with epsiki, anchored at objective 2.
%   [alpha, info] = linesearch_wolfe_d42(f, g, x, dvec, opts)
%   Delegates to linesearch_dwolfe with opts.anchor = 2 and opts.epsiki.
%   Refactored by: Dr. Mohammed Alshahrani
if nargin < 5 || (numel(opts)==0), opts = struct(); end
opts.anchor = 2;
opts.epsiki = getfielddef(opts,'epsiki',1e2);
[alpha, info] = linesearch_dwolfe(f, g, x, dvec, opts);
info.name = 'dwolfe42';
end
