function G = jos2_g(x)
% jos2_g  Gradients for JOS2/ZDT-like two-objective test.
%
%   Properties:
%     - convex: no
%     - domain: x in [0, 1]^n (typical), f1 uses x1 in [0,1]
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:); n = numel(x);
g = 1; if n >= 2, g = 1 + 9*sum(x(2:end))/max(n-1,1); end
z = x(1) / g;

% Safe handling near z=0 for fractional powers
epsz = 1e-12; z_safe = max(z, epsz);

% Grad f1
g1 = zeros(n,1); g1(1) = 1;

% Grad f2
% For i=1: df2/dx1 = -0.25 z^(-0.75) - 4 z^3
df2_dx1 = -0.25*realpow(z_safe,-0.75) - 4*realpow(z,3);

% For i>=2: df2/dx_i = (9/(n-1)) * (1 - 0.75 z^{0.25} + 3 z^4)
coeff = (n>=2) * (9/max(n-1,1));
df2_dxi_common = (1 - 0.75*realpow(z,0.25) + 3*realpow(z,4));
g2 = zeros(n,1);
g2(1) = df2_dx1;
if n >= 2
  g2(2:end) = coeff * df2_dxi_common;
end

G = {g1, g2};

end
