function G = mop7_g(x)
% mop7_g  Gradients for MOP7.

x = x(:); n = numel(x);
if n < 2, error('mop7_g:dim','MOP7 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);
% f1 grad
g1(1) = (x1-2);
g1(2) = 2*(x2+1)/13;
% f2 grad
g2(1) = (x1+x2-3)/18 - (-x1+x2+2)/4;
g2(2) = (x1+x2-3)/18 + (-x1+x2+2)/4;
% f3 grad
g3(1) = 2*(x1+2*x2-1)/175 - 2*(-x1+2*x2)/17;
g3(2) = 4*(x1+2*x2-1)/175 + 4*(-x1+2*x2)/17;

G = {g1, g2, g3};

end

