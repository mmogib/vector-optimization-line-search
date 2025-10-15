function F = fds_f(x)
% fds_f  FDS three-objective test (consolidated from legacy d=7,8,9).
%   F = fds_f(x) returns a 3x1 vector [f1; f2; f3]
%   Definitions (minimize):
%     f1(x) = (1/n^2) * sum_{i=1}^n i * (x_i - i)^4
%     f2(x) = exp(mean(x)) + ||x||_2^2
%     f3(x) = (1/(n(n+1))) * sum_{i=1}^n i*(n-i+1) * exp(-x_i)
%
%   Properties:
%     - convex: yes (sum of convex terms: quartic, exp(mean), squared norm, exp(-x))
%     - domain: x_i in [-2, 2]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: J. Fliege, L.M.G. Drummond, B.F. Svaiter, Newton's method for multiobjective optimization. SIAM Journal on Optimization, 20(2)(2009) 602-626.

n = numel(x);
idx = (1:n)';

f1 = (1/(n^2)) * sum(idx .* (x(:) - idx).^4);
f2 = exp(mean(x)) + sum(x(:).^2);
f3 = (1/(n*(n+1))) * sum(idx .* (n - idx + 1) .* exp(-x(:)));

F = [f1; f2; f3];

end



