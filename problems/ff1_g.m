function G = ff1_g(x)
% ff1_g  Gradients for FF1.

n = numel(x);
if n < 2, error('ff1_g:dim','FF1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

e1 = exp(-((x1-1)^2 + (x2+1)^2));
e2 = exp(-((x1+1)^2 + (x2-1)^2));

% f1 = 1 - e^{-a}; df1/dx = e^{-a} * 2*(x - shift)
g1 = zeros(n,1);
g1(1) = 2*(x1-1) * e1;
g1(2) = 2*(x2+1) * e1;

% f2
g2 = zeros(n,1);
g2(1) = 2*(x1+1) * e2;
g2(2) = 2*(x2-1) * e2;

G = {g1, g2};

end

