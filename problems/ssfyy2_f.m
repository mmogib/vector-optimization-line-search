function F = ssfyy2_f(x)
% ssfyy2_f  SSFYY2 two-objective test.
%   f1 = x1^2 + x2^2
%   f2 = (x1 - 2)^2 + (x2 - 2)^2 - cos(pi * x1 / 2)
%   Domain: x_i in [-100,100]

if numel(x) < 2, error('ssfyy2_f:dim','Requires at least 2 variables'); end
x1 = x(1); x2 = x(2);
F = [x1^2 + x2^2; (x1 - 2)^2 + (x2 - 2)^2 - cos(pi * x1 / 2)];

end

