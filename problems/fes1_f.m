function F = fes1_f(x)
% fes1_f  FES1 two-objective test (per user-provided definitions).
%   f1 = sum_{i=1..n} | x_i - c_i |^{0.5}, where c_i = exp(0.5*exp((i/n)^2)/3)
%   f2 = sum_{i=1..n} ( x_i - 0.5*cos(10*pi*i/n) - 0.5 )^2
%   Properties:
%     - convex: no (|x-c|^{0.5} is nonconvex)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:);
n = numel(x);

i = (1:n)';
ci = exp(0.5*exp((i./n).^2) / 3);
f1 = sum( abs(x - ci).^0.5 );
f2 = sum( ( x - 0.5*cos(10*pi*i/n) - 0.5 ).^2 );

F = [f1; f2];

end

