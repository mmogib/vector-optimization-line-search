function F = ltdz1_f(x)
% ltdz1_f  LTDZ1 three-objective maximization converted to minimization.
%   Original (maximize):
%     f1 = 3 - (1+x3)*cos(pi*x1/2)*cos(pi*x2/2)
%     f2 = 3 - (1+x3)*cos(pi*x1/2)*sin(pi*x2/2)
%     f3 = 3 - (1+x3)*sin(pi*x1/2)
%   We minimize -f_k.
%
%   Properties:
%     - convex: no (trigonometric functions)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 3, error('ltdz1_f:dim','LTDZ1 expects at least 3 variables'); end
x1 = x(1); x2 = x(2); x3 = x(3);
c1 = cos(pi*x1/2); s1 = sin(pi*x1/2);
c2 = cos(pi*x2/2); s2 = sin(pi*x2/2);

f1_max = 3 - (1 + x3) * c1 * c2;
f2_max = 3 - (1 + x3) * c1 * s2;
f3_max = 3 - (1 + x3) * s1;
F = [-f1_max; -f2_max; -f3_max];

end

