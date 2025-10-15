function G = ltdz1_g(x)
% ltdz1_g  Gradients for LTDZ1 (converted to minimization).

n = numel(x); if n < 3, error('ltdz1_g:dim','Need at least 3 variables'); end
x1 = x(1); x2 = x(2); x3 = x(3);
c1 = cos(pi*x1/2); s1 = sin(pi*x1/2);
c2 = cos(pi*x2/2); s2 = sin(pi*x2/2);
dp = pi/2;

% f1_max = 3 - (1+x3)*c1*c2
df1max_dx1 = - (1+x3) * (-s1*dp) * c2;
df1max_dx2 = - (1+x3) * c1 * (-s2*dp);
df1max_dx3 = - c1*c2;

% f2_max = 3 - (1+x3)*c1*s2
df2max_dx1 = - (1+x3) * (-s1*dp) * s2;
df2max_dx2 = - (1+x3) * c1 * ( c2*dp);
df2max_dx3 = - c1*s2;

% f3_max = 3 - (1+x3)*s1
df3max_dx1 = - (1+x3) * ( c1*dp);
df3max_dx3 = - s1;

g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);
% Convert to minimization grads (negate)
g1(1) = -df1max_dx1; g1(2) = -df1max_dx2; g1(3) = -df1max_dx3;
g2(1) = -df2max_dx1; g2(2) = -df2max_dx2; g2(3) = -df2max_dx3;
g3(1) = -df3max_dx1;                 g3(3) = -df3max_dx3;

G = {g1, g2, g3};

end

