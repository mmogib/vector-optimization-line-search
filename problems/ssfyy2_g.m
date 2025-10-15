function G = ssfyy2_g(x)
% ssfyy2_g  Gradients for SSFYY2.

n = numel(x);
if n < 2, error('ssfyy2_g:dim','Requires at least 2 variables'); end

g1 = zeros(n,1);
g2 = zeros(n,1);

% f1 grad
g1(1) = 2*x(1); g1(2) = 2*x(2);

% f2 grad
% d/dx1: 2(x1-2) + (pi/2) sin(pi x1 / 2)
g2(1) = 2*(x(1) - 2) + (pi/2) * sin(pi * x(1) / 2);
g2(2) = 2*(x(2) - 2);

G = {g1, g2};

end

