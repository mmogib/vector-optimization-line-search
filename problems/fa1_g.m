function G = fa1_g(x)
% fa1_g  Gradients for FA1 (3 objectives).

x = x(:); n = numel(x);
if n < 3, error('fa1_g:dim','FA1 expects at least 3 variables'); end
x1 = x(1); x2 = x(2); x3 = x(3);

den = (1 - exp(-4));
dy = 4*exp(-4*x1) / den; % dy/dx1
y = (1 - exp(-4*x1)) / den;

% f1
g1 = zeros(n,1); g1(1) = dy;

% f2
% f2 = (x2+1) * (1 - (y/(x2+1))^0.5)
% df2/dx1 = -0.5 * y^{-0.5} * dy (see derivation)
epsy = max(y, 1e-12);
df2_dx1 = -0.5 * epsy^(-0.5) * dy;
% df2/dx2 = 1 - 0.5 * (y/(x2+1))^{0.5} / ( (x2+1)^{0.5} )
df2_dx2 = 1 - 0.5 * (y/(x2+1))^(0.5);
g2 = zeros(n,1); g2(1) = df2_dx1; g2(2) = df2_dx2;

% f3
% f3 = (x3+1) * (1 - (y/(x3+1))^0.1)
% df3/dx1 = -0.1 * y^{-0.9} * dy
df3_dx1 = -0.1 * max(y,1e-12)^(-0.9) * dy;
% df3/dx3 = 1 - 0.9 * (y/(x3+1))^{0.1}
df3_dx3 = 1 - 0.9 * (y/(x3+1))^(0.1);
g3 = zeros(n,1); g3(1) = df3_dx1; g3(3) = df3_dx3;

G = {g1, g2, g3};

end

