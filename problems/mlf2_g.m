function G = mlf2_g(x)
% mlf2_g  Gradients for MLF2 (converted to minimization).

n = numel(x); x1 = x(1); x2 = x(2);

S11 = x1 + x2 - 11; S7 = x1 + x2 - 7;
df1max_dx = -2*(S11 + S7); % same for x1 and x2

S11p = 2*x1 + 2*x2 - 11; S7p = 2*x1 + 2*x2 - 7;
df2max_dx = -4*(S11p + S7p); % due to chain rule (derivatives 2)

g1 = zeros(n,1); g2 = zeros(n,1);
g1(1) = -df1max_dx; g1(2) = -df1max_dx;
g2(1) = -df2max_dx; g2(2) = -df2max_dx;

G = {g1, g2};

end

