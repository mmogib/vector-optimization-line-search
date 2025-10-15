function F = vu2_f(x)
% vu2_f  VU2 two-objective analytic problem.
%   f1 = x1 + x2 + 1
%   f2 = x1^2 + 2*x2 - 1
%
%   Properties:
%     - convex: yes (linear and convex quadratic)
%     - domain: x_i in [-3, 3]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('vu2_f:dim','VU2 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
F = [x1 + x2 + 1; x1^2 + 2*x2 - 1];

end

