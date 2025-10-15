function G = mop5_g(x)
% mop5_g  Gradients for MOP5.

x = x(:); n = numel(x);
if n < 2, error('mop5_g:dim','MOP5 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
r2 = x1^2 + x2^2;

% f1 grad: d/dx = x + 2*cos(r2).*x
g1 = zeros(n,1);
g1(1) = x1 + 2*cos(r2)*x1;
g1(2) = x2 + 2*cos(r2)*x2;

% f2 grad
g2 = zeros(n,1);
g2(1) = 3*(3*x1-2*x2+4)/4 + 2*(x1-x2+1)/27;
g2(2) = -(3*x1-2*x2+4)/2 - 2*(x1-x2+1)/27;

% f3 grad
g3 = zeros(n,1);
g3(1) = -2*x1/(r2+1)^2 + 2.2*x1*exp(-r2);
g3(2) = -2*x2/(r2+1)^2 + 2.2*x2*exp(-r2);

G = {g1, g2, g3};

end

