function G = tkly1_g(x)
% tkly1_g  Gradients for TKLY1.

x = x(:); n = numel(x);
if n < 4, error('tkly1_g:dim','TKLY1 expects at least 4 variables'); end

x1 = x(1);
P = ones(3,1);
A = zeros(3,1); B = zeros(3,1);
for k = 2:4
  a = (x(k) - 0.1)/0.04; A(k-1) = a;
  b = (x(k) - 0.9)/0.4; B(k-1) = b;
  P(k-1) = 2.0 - exp(-a^2) - 0.8*exp(-b^2);
end
prodP = prod(P);

% f1 grad
g1 = zeros(n,1); g1(1) = 1;

% f2 grad
g2 = zeros(n,1);
% d/dx1
g2(1) = prodP;
% d/dxk for k=2..4
for k = 2:4
  % dP_k/dx_k
  Ak = A(k-1); Bk = B(k-1);
  dPk = 2*Ak/0.04^2 * exp(-Ak^2) + 1.6*Bk/0.4^2 * exp(-Bk^2);
  % contribution: x1 * (prod_{j!=k} P_j) * dP_k
  g2(k) = x1 * (prodP / P(k-1)) * dPk;
end

G = {g1, g2};

end

