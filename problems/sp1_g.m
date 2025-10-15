function G = sp1_g(x)
% sp1_g  Gradients for SP1 two-objective analytic problem.
%   G = sp1_g(x)
%   - x: decision vector (uses first 2 components)
%   - G: 1x2 cell array of gradients {g1, g2}

n = numel(x);
if n < 2
  error('sp1_g:dim', 'SP1 expects at least 2 decision variables.');
end

g1 = zeros(n,1);
g2 = zeros(n,1);

% f1 = (x1 - 1)^2 + (x1 - x2)^2
% df1/dx1 = 2(x1 - 1) + 2(x1 - x2)
% df1/dx2 = -2(x1 - x2)
g1(1) = 2*(x(1) - 1) + 2*(x(1) - x(2));
g1(2) = -2*(x(1) - x(2));

% f2 = (x2 - 3)^2 + (x1 - x2)^2
% df2/dx1 = 2(x1 - x2)
% df2/dx2 = 2(x2 - 3) - 2(x1 - x2)
g2(1) = 2*(x(1) - x(2));
g2(2) = 2*(x(2) - 3) - 2*(x(1) - x(2));

G = {g1, g2};

end

