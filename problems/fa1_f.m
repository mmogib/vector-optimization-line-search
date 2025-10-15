function F = fa1_f(x)
% fa1_f  FA1 three-objective test.
%   y = (1 - exp(-4*x1)) / (1 - exp(-4))
%   f1 = y
%   f2 = (x2+1) * (1 - (y/(x2+1))^0.5)
%   f3 = (x3+1) * (1 - (y/(x3+1))^0.1)
%   Properties:
%     - convex: no (concave fractional powers and multiplicative terms)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:);
if numel(x) < 3, error('fa1_f:dim','FA1 expects at least 3 variables'); end
x1 = x(1); x2 = x(2); x3 = x(3);

den = (1 - exp(-4));
y = (1 - exp(-4*x1)) / den;

f1 = y;
f2 = (x2+1) * (1 - (y/(x2+1))^0.5);
f3 = (x3+1) * (1 - (y/(x3+1))^0.1);

F = [f1; f2; f3];

end

