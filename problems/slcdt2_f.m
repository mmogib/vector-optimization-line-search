function F = slcdt2_f(x)
% slcdt2_f  SLCDT2 three-objective test (legacy P10 mapping), n=10.
%   Based on legacy definitions in f1/f2/f3 for d==10.
%
%   Properties:
%     - convex: yes (sum of squared/quartic terms)
%     - domain: x_i in [-100, 100]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: O. Schütze, M. Laumanns, C.A.C. Coello, M. Dellnitz, E. Talbi, Convergence of stochastic search algorithms to finite size pareto set approximations. Journal of Global Optimization, 41(2008) 559-577.

x = x(:); n = numel(x);
if n < 10, error('slcdt2_f:dim','SLCDT2 expects n=10'); end

f1 = sum((x(2:10) - 1).^2) + (x(1) - 1)^4;
f2 = sum((x(3:10) + 1).^2) + (x(1) + 1)^2 + (x(2) + 1)^4;
f3 = (x(1)-1)^2 + (x(2)+1)^2 + (x(3)-1)^4 + (x(4)+1)^2 + (x(5)-1)^2 + (x(6)+1)^2 + (x(7)-1)^2 + (x(8)+1)^2 + (x(9)-1)^2 + (x(10)+1)^2;

F = [f1; f2; f3];

end



