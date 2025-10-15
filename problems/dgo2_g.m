function G = dgo2_g(x)
% dgo2_g  Gradients for DGO2.
%   G = dgo2_g(x) returns {g1, g2}, each n x 1 with only first comp nonzero.

n = numel(x);
if n < 1, error('dgo2_g:dim','Input x must have at least 1 element'); end

xi = x(1);
g1 = zeros(n,1);
g2 = zeros(n,1);

g1(1) = 2*xi;
rad = 81 - xi^2;
if rad <= 0
  g2(1) = sign(xi) * Inf; % undefined; indicate large magnitude
else
  g2(1) = xi / sqrt(rad);
end

G = {g1, g2};

end

