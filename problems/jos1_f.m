function F = jos1_f(x)
% jos1_f  JOS1 two-objective quadratic sums [JOS1995].
%   F = jos1_f(x)
%   - f1 = sum_{i=1}^n i * x_i^2
%   - f2 = (1/n) * sum_{i=1}^n (x_i - 2)^2
%
%   Properties:
%     - convex: yes (sum of convex quadratics)
%     - domain: x_i in [-10000, 10000]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

x = x(:); n = numel(x);
idx = (1:n)';
f1 = sum(idx .* (x.^2));
f2 = sum((x - 2).^2) / max(n,1);
F = [f1; f2];

end


