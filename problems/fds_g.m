function G = fds_g(x)
% fds_g  Gradients for FDS test (consolidated from legacy d=7,8,9).
%   G = fds_g(x) returns a 1x3 cell array {g1, g2, g3}
%   where each gk is n x 1.

n = numel(x);
idx = (1:n)';

% g1 = (4/n^2) * i * (x_i - i)^3
g1 = (4/(n^2)) * idx .* (x(:) - idx).^3;

% g2 = exp(mean(x))/n * 1 + 2*x
g2 = (exp(mean(x)) / n) * ones(n,1) + 2 * x(:);

% g3 = -(1/(n(n+1))) * i*(n-i+1) * exp(-x_i)
g3 = -(1/(n*(n+1))) * (idx .* (n - idx + 1)) .* exp(-x(:));

G = {g1, g2, g3};

end

