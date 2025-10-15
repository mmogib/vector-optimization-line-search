function G = dgo1_g(x)
% dgo1_g  Gradients for DGO1.
%   G = dgo1_g(x) returns {g1, g2}, each n x 1 with only first comp nonzero.

n = numel(x);
if n < 1, error('dgo1_g:dim','Input x must have at least 1 element'); end

g1 = zeros(n,1);
g2 = zeros(n,1);
g1(1) = cos(x(1));
g2(1) = cos(x(1) + 0.7);
G = {g1, g2};

end

