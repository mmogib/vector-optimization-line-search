function G = kur1_g(x)
% kur1_g  Gradients for Kursawe two-objective test.

x = x(:); n = numel(x);
g1 = zeros(n,1);
for i = 1:max(n-1,0)
  xi = x(i); xip = x(i+1);
  r = sqrt(xi^2 + xip^2);
  if r > 0
    c = 2 * exp(-0.2*r) / r; % since -10*-0.2 = 2
    g1(i)   = g1(i)   + c * xi;
    g1(i+1) = g1(i+1) + c * xip;
  end
end

% f2 grad: d/dx (|x|^0.8) = 0.8*sign(x)*|x|^{-0.2}
g2 = 0.8 * sign(x) .* (abs(x).^( -0.2 ));
g2(~isfinite(g2)) = 0; % at x=0, define subgradient 0
g2 = g2 + 15*(x.^2) .* cos(x.^3);

G = {g1, g2};

end

