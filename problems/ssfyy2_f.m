function F = ssfyy2_f(x)
% ssfyy2_f  SSFYY2 two-objective test.
%   f1 = x1^2 + x2^2
%   f2 = (x1 - 2)^2 + (x2 - 2)^2 - cos(pi * x1 / 2)
%
%   Properties:
%     - convex: no (cosine term in f2)
%     - domain: x_i in [-100, 100]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

if numel(x) < 2, error('ssfyy2_f:dim','Requires at least 2 variables'); end
x1 = x(1); x2 = x(2);
F = [x1^2 + x2^2; (x1 - 2)^2 + (x2 - 2)^2 - cos(pi * x1 / 2)];

end


