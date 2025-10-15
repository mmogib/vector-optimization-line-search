function F = mop7_f(x)
% mop7_f  MOP7 three-objective test (legacy P6 mapping).
%   f1 = (x1-2)^2/2 + (x2+1)^2/13 + 3
%   f2 = (x1+x2-3)^2/36 + (-x1+x2+2)^2/8 - 17
%   f3 = (x1+2*x2-1)^2/175 + (-x1+2*x2)^2/17 - 13
%
%   Properties:
%     - convex: yes (sum of squared affine terms)
%     - domain: x_i in [-400, 400]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

x = x(:);
if numel(x) < 2, error('mop7_f:dim','MOP7 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
f1 = (x1-2)^2/2 + (x2+1)^2/13 + 3;
f2 = (x1+x2-3)^2/36 + (-x1+x2+2)^2/8 - 17;
f3 = (x1+2*x2-1)^2/175 + (-x1+2*x2)^2/17 - 13;
F = [f1; f2; f3];

end



