function F = dgo1_f(x)
% dgo1_f  DGO1 one-dimensional two-objective problem.
%   F = dgo1_f(x)
%   f1(x) = sin(x)
%   f2(x) = sin(x + 0.7)
%   Properties:
%     - convex: no (trigonometric objectives)
%     - domain: x in [-10, 13]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

if isempty(x), error('dgo1_f:dim','Input x must be non-empty'); end
xi = x(1);
F = [sin(xi); sin(xi + 0.7)];

end



