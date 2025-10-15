function G = sk1_g(x)
% sk1_g  Gradients for SK1 (converted to minimization).

n = numel(x);
xi = x(1);

% d/dx of original f1_max, then negate
df1max = -4*xi^3 - 9*xi^2 + 20*xi + 10;
df2max = -2*xi^3 + 6*xi^2 + 20*xi - 10;

g1 = zeros(n,1); g2 = zeros(n,1);
g1(1) = -df1max; % gradient of -f1_max
g2(1) = -df2max;

G = {g1, g2};

end

