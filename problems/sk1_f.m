function F = sk1_f(x)
% sk1_f  SK1 two-objective maximization test converted to minimization.
%   Original (maximize):
%     f1 = -x^4 - 3x^3 + 10x^2 + 10x + 10
%     f2 = -0.5x^4 + 2x^3 + 10x^2 - 10x + 5
%   We minimize -f1, -f2.

xi = x(1);
f1_max = -xi^4 - 3*xi^3 + 10*xi^2 + 10*xi + 10;
f2_max = -0.5*xi^4 + 2*xi^3 + 10*xi^2 - 10*xi + 5;
F = [-f1_max; -f2_max];

end

