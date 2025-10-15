function G = sch1_g(x)
% sch1_g  Gradients for Sch1.

n = numel(x); xi = x(1);
g1 = zeros(n,1); g2 = zeros(n,1);

% piecewise slope for f1
if xi <= 1
  s = -1;
elseif xi <= 3
  s = 1;
elseif xi <= 4
  s = -1;
else
  s = 1;
end
g1(1) = s;

% f2 = (x-5)^2
g2(1) = 2*(xi - 5);

G = {g1, g2};

end

