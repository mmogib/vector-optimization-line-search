function G = sk2_g(x)
% sk2_g  Gradients for SK2 (converted to minimization).

x = x(:); n = numel(x);
if n < 4, error('sk2_g:dim','SK2 expects at least 4 variables'); end

% f1_max grad
g1max = zeros(n,1);
g1max(1) = -2*(x(1)-2);
g1max(2) = -2*(x(2)+3);
g1max(3) = -2*(x(3)-5);
g1max(4) = -2*(x(4)-4);

% f2_max grad: quotient rule
S = sin(x(1)) + sin(x(2)) + sin(x(3)) + sin(x(4));
den = 1 + (sum(x.^2))/100;
dS = zeros(n,1);
dS(1:4) = cos(x(1:4));
dDen = (2/100) * x; % derivative of sum(x^2)/100
g2max = (dS * den - S * dDen) / (den^2);

% Convert to minimization gradients (negate)
g1 = -g1max; g2 = -g2max;
G = {g1, g2};

end

