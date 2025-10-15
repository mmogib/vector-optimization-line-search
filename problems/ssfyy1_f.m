function F = ssfyy1_f(x)
% ssfyy1_f  SSFYY1 two-objective test.
%   F = ssfyy1_f(x)
%   f1 = x1^2 + x2^2
%   f2 = (x1 - 2)^2 + (x2 - 2)^2
%
%   Properties:
%     - convex: yes (sum of convex quadratics)
%     - domain: x_i in [-100, 100]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('ssfyy1_f:dim','Requires at least 2 variables'); end
x1 = x(1); x2 = x(2);
F = [x1^2 + x2^2; (x1 - 2)^2 + (x2 - 2)^2];

end

