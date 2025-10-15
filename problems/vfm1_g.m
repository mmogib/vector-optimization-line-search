function G = vfm1_g(x)
% vfm1_g  Gradients for VFM1 (3 objectives).

n = numel(x);
if n < 2, error('vfm1_g:dim','VFM1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);

% f1 grad
g1(1) = 2*x1; g1(2) = 2*(x2 - 1);

% f2 grad: d/dx1 = 2*(x1 + x2 - 1); d/dx2 = 2*(x1 + x2 - 1)
t = 2*(x1 + x2 - 1);
g2(1) = t; g2(2) = t;

% f3 grad
g3(1) = 2*(x1 - 1); g3(2) = 2*x2;

G = {g1, g2, g3};

end

