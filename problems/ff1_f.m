function F = ff1_f(x)
% ff1_f  FF1 two-objective analytic test.
%   F = ff1_f(x)
%   f1(x1,x2) = 1 - exp(-((x1-1)^2 + (x2+1)^2))
%   f2(x1,x2) = 1 - exp(-((x1+1)^2 + (x2-1)^2))
%
%   Properties:
%     - convex: no (Gaussian bumps are nonconvex)
%     - domain: not specified
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('ff1_f:dim','FF1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
e1 = exp(-((x1-1)^2 + (x2+1)^2));
e2 = exp(-((x1+1)^2 + (x2-1)^2));
F = [1 - e1; 1 - e2];

end

