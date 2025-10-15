function F = qv1_f(x)
% qv1_f  QV1 two-objective test [QV2000].
%   f1 = ( (1/n) * sum (x_i + cos(2pi x_i) + 10) )^0.25
%   f2 = ( (1/n) * sum ((x_i-1.5)^2 - 10*cos(2pi(x_i-1.5)) + 10) )^0.25
%
%   Properties:
%     - convex: no (nonlinear trigonometric terms with fractional power)
%     - domain: x_i in [-5.12, 5.12]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:); n = numel(x);
A1 = mean(x + cos(2*pi*x) + 10);
A2 = mean((x - 1.5).^2 - 10*cos(2*pi*(x - 1.5)) + 10);
F = [realpow(A1, 0.25); realpow(A2, 0.25)];

end

