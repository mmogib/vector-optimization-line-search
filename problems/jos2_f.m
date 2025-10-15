function F = jos2_f(x)
% jos2_f  JOS2/ZDT-like two-objective test [JOS1995].
%   f1(x) = x1
%   g(x)  = 1 + 9*sum_{i=2..n} x_i / (n-1)
%   f2(x) = g * (1 - (x1/g)^{0.25} - (x1/g)^4)
%
%   Properties:
%     - convex: no
%     - domain: x in [0, 1]^n (typical), f1 uses x1 in [0,1]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:); n = numel(x);
f1 = x(1);
if n >= 2
  g = 1 + 9*sum(x(2:end)) / max(n-1,1);
else
  g = 1;
end
z = f1 / g;
F = [f1; g * (1 - realpow(z,0.25) - realpow(z,4))];

end
