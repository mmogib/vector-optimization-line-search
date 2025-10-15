function F = sk2_f(x)
% sk2_f  SK2 two-objective maximization test converted to minimization.
%   Original (maximize):
%     f1 = -(x1-2)^2 - (x2+3)^2 - (x3-5)^2 - (x4-4)^2 + 5
%     f2 = (sin x1 + sin x2 + sin x3 + sin x4) / (1 + (sum x_i^2)/100)
%   We minimize -f1, -f2.

x = x(:);
if numel(x) < 4, error('sk2_f:dim','SK2 expects at least 4 variables'); end

f1_max = - (x(1)-2)^2 - (x(2)+3)^2 - (x(3)-5)^2 - (x(4)-4)^2 + 5;
den = 1 + (sum(x.^2))/100;
f2_max = (sin(x(1)) + sin(x(2)) + sin(x(3)) + sin(x(4))) / den;

F = [-f1_max; -f2_max];

end

