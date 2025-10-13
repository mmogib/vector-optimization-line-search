function f = bk1_f(x)
% bk1_f  BK1 two-objective test problem [BK1996].
%   f = bk1_f(x)
%   - x: decision vector (uses first 2 components)
%   - f: 2x1 objective vector [f1; f2]
%
%   Definitions (minimize):
%     f1(x1,x2) = x1^2 + x2^2
%     f2(x1,x2) = (x1 - 5)^2 + (x2 - 5)^2
%
%   Parameter domain (from Table XVI): x_i in [-5, 10].
%
%   Reference: [BK1996] T. T. Binh and U. Korn (1996).
%   "An evolution strategy for the multiobjective optimization," Proc. 2nd Int. Conf. Genetic Algorithms.

if numel(x) < 2
  error('bk1_f:dim', 'BK1 expects at least 2 decision variables.');
end

x1 = x(1); x2 = x(2);
f1 = x1^2 + x2^2;
f2 = (x1 - 5)^2 + (x2 - 5)^2;
f = [f1; f2];

end

