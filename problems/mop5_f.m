function F = mop5_f(x)
% mop5_f  MOP5 three-objective test (legacy P5 mapping).
%   f1 = 0.5*(x1^2+x2^2) + sin(x1^2 + x2^2)
%   f2 = (3x1-2x2+4)^2/8 + (x1-x2+1)^2/27 + 15
%   f3 = 1/(x1^2+x2^2+1) - 1.1*exp(-(x1^2+x2^2))
%
%   Properties:
%     - convex: no (nonlinear sinusoidal and exponential terms)
%     - domain: x_i in [-1, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

x = x(:);
if numel(x) < 2, error('mop5_f:dim','MOP5 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
r2 = x1^2 + x2^2;
f1 = 0.5*r2 + sin(r2);
f2 = (3*x1-2*x2+4)^2/8 + (x1-x2+1)^2/27 + 15;
f3 = 1/(r2 + 1) - 1.1*exp(-r2);
F = [f1; f2; f3];

end



