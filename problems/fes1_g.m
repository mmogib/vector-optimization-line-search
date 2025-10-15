function G = fes1_g(x)
% fes1_g  Gradients for FES1.

x = x(:); n = numel(x);
i = (1:n)';
ci = exp(0.5*exp((i./n).^2) / 3);

% f1 grad: 0.5 * sign(x - c) .* |x - c|^{-0.5}
diff = x - ci;
epsv = 1e-12;
g1 = 0.5 * sign(diff) .* (max(abs(diff), epsv)).^(-0.5);

% f2 grad: 2*(x - 0.5*cos(10*pi*i/n) - 0.5)
g2 = 2 * ( x - 0.5*cos(10*pi*i/n) - 0.5 );

G = {g1, g2};

end

