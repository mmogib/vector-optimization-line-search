function G = fes2_g(x)
% fes2_g  Gradients for FES2 (3 objectives).

x = x(:); n = numel(x);
i = (1:n)';

% f1 grad: 2*(x - 0.5*cos(10*pi*i/n) - 0.5)
g1 = 2 * ( x - 0.5*cos(10*pi*i/n) - 0.5 );

% f2 grad: 0.5 * sign(x - t2) .* |x - t2|^{-0.5}
t2 = (sin(i-1).*cos(i-1)).^2;
epsv = 1e-12;
g2 = 0.5 * sign(x - t2) .* (max(abs(x - t2), epsv)).^(-0.5);

% f3 grad: 0.5 * sign(x - t3) .* |x - t3|^{-0.5}
t3 = 0.25*cos(i-1).*cos(2*i-2) + 0.5;
g3 = 0.5 * sign(x - t3) .* (max(abs(x - t3), epsv)).^(-0.5);

G = {g1, g2, g3};

end

