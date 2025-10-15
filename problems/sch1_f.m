function F = sch1_f(x)
% sch1_f  Sch1 two-objective piecewise test [S1985].
%   f1(x) is piecewise linear, f2(x) = (x-5)^2
%
%   Properties:
%     - convex: no (piecewise linear +/- slopes; nonconvex set)
%     - domain: not specified
%
%   Refactored by: Dr. Mohammed Alshahrani

xi = x(1);
if xi <= 1
  f1 = -xi;
elseif xi <= 3
  f1 = -2 + xi;
elseif xi <= 4
  f1 = 4 - xi;
else
  f1 = xi - 5;
end
f2 = (xi - 5)^2;
F = [f1; f2];

end

