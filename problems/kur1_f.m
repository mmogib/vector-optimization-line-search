function F = kur1_f(x)
% kur1_f  Kursawe (K1991) two-objective test (minimization).
%   f1(x) = sum_{i=1..n-1} -10 * exp(-0.2*sqrt(x_i^2 + x_{i+1}^2))
%   f2(x) = sum_{i=1..n} (|x_i|^0.8 + 5*sin(x_i^3))
%
%   Properties:
%     - convex: no (nonlinear exponential and trigonometric terms)
%     - domain: x_i in [-5, 5]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:); n = numel(x);
f1 = 0;
for i = 1:max(n-1,0)
  r = sqrt(x(i)^2 + x(i+1)^2);
  f1 = f1 + (-10)*exp(-0.2*r);
end
f2 = sum(abs(x).^0.8 + 5*sin(x.^3));
F = [f1; f2];

end

