function G = fes3_g(x)
% fes3_g  Gradients for FES3 (4 objectives).

x = x(:); n = numel(x);
i = (1:n)';
epsv = 1e-12;

t1 = exp((i./n).^2) / 3;
g1 = 0.5 * sign(x - t1) .* (max(abs(x - t1), epsv)).^(-0.5);

t2 = (sin(i-1).*cos(i-1)).^2;
g2 = 0.5 * sign(x - t2) .* (max(abs(x - t2), epsv)).^(-0.5);

t3 = 0.25*cos(i-1).*cos(2*i-2) + 0.5;
g3 = 0.5 * sign(x - t3) .* (max(abs(x - t3), epsv)).^(-0.5);

g4 = 2 * ( x - 0.5*sin(1000*pi*i/n) - 0.5 );

G = {g1, g2, g3, g4};

end

