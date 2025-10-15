function G = le1_g(x)
% le1_g  Gradients for LE1 two-objective test.

n = numel(x);
if n < 2, error('le1_g:dim','LE1 expects at least 2 variables'); end

g1 = zeros(n,1); g2 = zeros(n,1);

% f1 = x1
g1(1) = 1;

% f2 = (x1-0.5)^2 + |x2-0.5|^{0.25}
g2(1) = 2*(x(1) - 0.5);
dx = x(2) - 0.5;
epsv = 1e-12;
if abs(dx) < epsv
  dabs_pow = 0; % subgradient chosen as 0 at kink
else
  dabs_pow = 0.25 * sign(dx) * abs(dx)^( -0.75 );
end
g2(2) = dabs_pow;

G = {g1, g2};

end

