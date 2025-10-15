function F = vfm1_f(x)
% vfm1_f  VFM1 three-objective analytic problem.
%   f1 = x1^2 + (x2 - 1)^2
%   f2 = (x1 + (x2 - 1))^2 + 1
%   f3 = (x1 - 1)^2 + x2^2 + 2
%
%   Properties:
%     - convex: yes (sum of convex quadratics)
%     - domain: x_i in [-2, 2]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('vfm1_f:dim','VFM1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
f1 = x1^2 + (x2 - 1)^2;
f2 = (x1 + (x2 - 1))^2 + 1;
f3 = (x1 - 1)^2 + x2^2 + 2;
F = [f1; f2; f3];

end

