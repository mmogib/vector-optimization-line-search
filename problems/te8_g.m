function G = te8_g(x)
% te8_g  Gradients for TE8 test (consolidated from legacy d=2,3,4).
%   G = te8_g(x) returns a 1x3 cell array {g1, g2, g3}
%   where each gk is n x 1.

n = numel(x);

% g1 = grad f1 = 3*x.^2
g1 = 3 * x(:).^2;

% g2 = grad f2 = [2*(x(1:n-1)-4); 2*x(n)]
if n >= 2
  g2 = [2*(x(1:n-1) - 4); 2*x(n)];
else
  g2 = 2*x(1);
end

% g3 = grad f3 = [-1/x1; 10*x(2:n)] with guard at x1<=0
g3 = zeros(n,1);
if x(1) <= 0
  g3(1) = -Inf;
else
  g3(1) = -1 / x(1);
end
g3(2:end) = 10 * x(2:end);

G = {g1, g2, g3};

end

