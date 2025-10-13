function G = bk1_g(x)
% bk1_g  Gradients for BK1 two-objective test [BK1996].
%   G = bk1_g(x)
%   - x: decision vector (uses first 2 components)
%   - G: 1x2 cell array of gradients {g1, g2}, each n x 1
%
%   Parameter domain (from Table XVI): x_i in [-5, 10].
%   See bk1_f for objective definitions and reference.

n = numel(x);
if n < 2
  error('bk1_g:dim', 'BK1 expects at least 2 decision variables.');
end

g1 = zeros(n,1); g2 = zeros(n,1);
g1(1) = 2*x(1);     g1(2) = 2*x(2);
g2(1) = 2*(x(1)-5); g2(2) = 2*(x(2)-5);
G = {g1, g2};

end

