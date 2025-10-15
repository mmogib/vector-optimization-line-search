function G = ssfyy1_g(x)
% ssfyy1_g  Gradients for SSFYY1.

n = numel(x);
if n < 2, error('ssfyy1_g:dim','Requires at least 2 variables'); end

g1 = zeros(n,1); g2 = zeros(n,1);
g1(1) = 2*x(1); g1(2) = 2*x(2);
g2(1) = 2*(x(1) - 2); g2(2) = 2*(x(2) - 2);
G = {g1, g2};

end

