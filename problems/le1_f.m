function F = le1_f(x)
% le1_f  LE1 two-objective test [LE1996].
%   f1(x1) = x1
%   f2(x1,x2) = (x1 - 0.5)^2 + |x2 - 0.5|^{0.25}
%   Note: fractional power uses absolute value for real-valued output.
%
%   Properties:
%     - convex: no (|x2-0.5|^{0.25} is nonconvex)
%     - domain: x_i in [-5, 10]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('le1_f:dim','LE1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
f1 = x1;
f2 = (x1 - 0.5)^2 + abs(x2 - 0.5)^(0.25);
F = [f1; f2];

end

