function G = vu1_g(x)
% vu1_g  Gradients for VU1 two-objective analytic problem.
%   G = vu1_g(x)
%   - x: decision vector (uses first 2 components)
%   - G: 1x2 cell array of gradients {g1, g2}

n = numel(x);
if n < 2
  error('vu1_g:dim', 'VU1 expects at least 2 decision variables.');
end

g1 = zeros(n,1);
g2 = zeros(n,1);

% f1 = 1 / (x1^2 + x2^2 + 1)
% df1/dx1 = -2*x1 / (x1^2 + x2^2 + 1)^2
% df1/dx2 = -2*x2 / (x1^2 + x2^2 + 1)^2
den = (x(1)^2 + x(2)^2 + 1);
g1(1) = -2*x(1) / (den^2);
g1(2) = -2*x(2) / (den^2);

% f2 = x1^2 + 3*x2^2 + 1
% grad = [2*x1; 6*x2]
g2(1) = 2*x(1);
g2(2) = 6*x(2);

G = {g1, g2};

end

