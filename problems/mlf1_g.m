function G = mlf1_g(x)
% mlf1_g  Gradients for MLF1.

n = numel(x); xi = x(1);
amp = 1 + xi/20;
g1 = zeros(n,1); g2 = zeros(n,1);
% d/dx [(1+x/20) sin x] = (1/20) sin x + (1+x/20) cos x
g1(1) = (1/20)*sin(xi) + amp*cos(xi);
% d/dx [(1+x/20) cos x] = (1/20) cos x - (1+x/20) sin x
g2(1) = (1/20)*cos(xi) - amp*sin(xi);
G = {g1, g2};

end

