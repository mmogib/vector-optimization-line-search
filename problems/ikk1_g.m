function G = ikk1_g(x)
% ikk1_g  Gradients for IKK1 (legacy P1 mapping).

x = x(:); n = numel(x);
if n < 2, error('ikk1_g:dim','IKK1 expects at least 2 variables'); end
g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);
g1(1) = 2*x(1);
g2(1) = 2*(x(1)-20);
g3(2) = 2*x(2);
G = {g1, g2, g3};

end

