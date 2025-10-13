function F = te8_f(x)
% te8_f  TE8 three-objective test (consolidated from legacy d=2,3,4).
%   F = te8_f(x) returns a 3x1 vector [f1; f2; f3]
%   Definitions (minimize):
%     f1(x) = sum_{i=1}^n x_i^3
%     f2(x) = sum_{i=1}^{n-1} (x_i - 4)^2 + x_n^2
%     f3(x) = -log(x_1) + 5 * sum_{i=2}^n x_i^2

n = numel(x);
f1 = sum(x(:).^3);
if n >= 2
  f2 = sum((x(1:n-1) - 4).^2) + x(n)^2;
else
  f2 = x(1)^2; % degenerate case
end
if x(1) <= 0
  % Guard log for robustness; legacy code assumes feasible x1>0
  f3 = Inf;
else
  f3 = -log(x(1)) + 5 * sum(x(2:end).^2);
end
F = [f1; f2; f3];

end

