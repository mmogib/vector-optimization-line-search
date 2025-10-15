function F = sp1_f(x)
% sp1_f  SP1 two-objective analytic problem.
%   F = sp1_f(x)
%   - x: decision vector (uses first 2 components)
%   - F: 2x1 objective vector [f1; f2]
%
%   Definitions (minimize):
%     f1(x1,x2) = (x1 - 1)^2 + (x1 - x2)^2
%     f2(x1,x2) = (x2 - 3)^2 + (x1 - x2)^2
%   Domain: x in R^2 (unbounded).

if numel(x) < 2
  error('sp1_f:dim', 'SP1 expects at least 2 decision variables.');
end

x1 = x(1); x2 = x(2);
f1 = (x1 - 1)^2 + (x1 - x2)^2;
f2 = (x2 - 3)^2 + (x1 - x2)^2;
F = [f1; f2];

end

