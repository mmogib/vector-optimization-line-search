function G = lrs1_g(x)
% lrs1_g  Gradients for LRS1.

n = numel(x);
if n < 2, error('lrs1_g:dim','LRS1 expects at least 2 variables'); end

g1 = zeros(n,1); g2 = zeros(n,1);

% f1 = x1 + 1
g1(1) = 1;

% f2 = x1^2 + 2 + x2^2/x1
epsd = 1e-12; x1 = x(1); x2 = x(2);
den = sign(x1) * max(abs(x1), epsd); % avoid zero division
g2(1) = 2*x1 - (x2^2) / (den^2);
g2(2) = 2*x2 / den;

G = {g1, g2};

end

