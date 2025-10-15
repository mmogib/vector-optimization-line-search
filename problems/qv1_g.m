function G = qv1_g(x)
% qv1_g  Gradients for QV1.

x = x(:); n = numel(x);

A1 = mean(x + cos(2*pi*x) + 10);
A2 = mean((x - 1.5).^2 - 10*cos(2*pi*(x - 1.5)) + 10);

% df1/dx_i
dA1 = (1/n) * (1 - 2*pi*sin(2*pi*x));
g1 = (0.25) * realpow(A1, -0.75) * dA1;

% df2/dx_i
dA2 = (1/n) * (2*(x - 1.5) + 20*pi*sin(2*pi*(x - 1.5)));
g2 = (0.25) * realpow(A2, -0.75) .* dA2;

G = {g1, g2};

end

