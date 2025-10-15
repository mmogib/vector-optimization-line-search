function F = vu1_f(x)
% vu1_f  VU1 two-objective analytic problem.
%   F = vu1_f(x)
%   - x: decision vector (uses first 2 components)
%   - F: 2x1 objective vector [f1; f2]
%
%   Definitions (minimize):
%     f1(x1,x2) = 1 / (x1^2 + x2^2 + 1)
%     f2(x1,x2) = x1^2 + 3*x2^2 + 1
%
%   Properties:
%     - convex: no (f1 = 1/(1+||x||^2) is convex in a neighborhood but not globally)
%     - domain: x_i in [-3, 3]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2
  error('vu1_f:dim', 'VU1 expects at least 2 decision variables.');
end

x1 = x(1); x2 = x(2);
den = x1^2 + x2^2 + 1;
f1 = 1 ./ den;
f2 = x1^2 + 3*x2^2 + 1;
F = [f1; f2];

end

