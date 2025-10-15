function G = far1_g(x)
% far1_g  Gradients for Far1.

n = numel(x);
if n < 2, error('far1_g:dim','Far1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

% Term helper returns value and gradients
term = @(C,K,a,b) deal(C*exp(K*(-(x1-a)^2 - (x2-b)^2)), ...
                      C*exp(K*(-(x1-a)^2 - (x2-b)^2)) * (-2*K*(x1-a)), ...
                      C*exp(K*(-(x1-a)^2 - (x2-b)^2)) * (-2*K*(x2-b)));

% f1 components
[t11, t11x, t11y] = term(-2, 15, 0.1, 0.0);
[t12, t12x, t12y] = term(-1, 20, 0.6, 0.6);
[t13, t13x, t13y] = term(+1, 20, 0.6,-0.6);
[t14, t14x, t14y] = term(+1, 20,-0.6, 0.6);
[t15, t15x, t15y] = term(+1, 20,-0.6,-0.6);

g1 = zeros(n,1);
g1(1) = t11x + t12x + t13x + t14x + t15x;
g1(2) = t11y + t12y + t13y + t14y + t15y;

% f2 components
[u11, u11x, u11y] = term(+2, 20, 0.2, 0.0);
[u12, u12x, u12y] = term(+1, 20, 0.4, 0.6);
[u13, u13x, u13y] = term(-1, 20, 0.5, 0.7);
[u14, u14x, u14y] = term(-1, 20, 0.5,-0.7);
[u15, u15x, u15y] = term(+1, 20, 0.4,-0.8);

g2 = zeros(n,1);
g2(1) = u11x + u12x + u13x + u14x + u15x;
g2(2) = u11y + u12y + u13y + u14y + u15y;

G = {g1, g2};

end

