function G = vu2_g(x)
% vu2_g  Gradients for VU2.

n = numel(x);
if n < 2, error('vu2_g:dim','VU2 expects at least 2 variables'); end

g1 = zeros(n,1); g2 = zeros(n,1);
g1(1) = 1; g1(2) = 1;
g2(1) = 2*x(1); g2(2) = 2;
G = {g1, g2};

end

