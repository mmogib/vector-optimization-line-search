function F = fds_f(x)
% fds_f  FDS three-objective test (consolidated from legacy d=7,8,9).
%   F = fds_f(x) returns a 3x1 vector [f1; f2; f3]
%   Definitions (minimize):
%     f1(x) = (1/n^2) * sum_{i=1}^n i * (x_i - i)^4
%     f2(x) = exp(mean(x)) + ||x||_2^2
%     f3(x) = (1/(n(n+1))) * sum_{i=1}^n i*(n-i+1) * exp(-x_i)

n = numel(x);
idx = (1:n)';

f1 = (1/(n^2)) * sum(idx .* (x(:) - idx).^4);
f2 = exp(mean(x)) + sum(x(:).^2);
f3 = (1/(n*(n+1))) * sum(idx .* (n - idx + 1) .* exp(-x(:)));

F = [f1; f2; f3];

end

