function F = mlf2_f(x)
% mlf2_f  MLF2 two-objective maximization converted to minimization.
%   f1_max = 5 - ((x1 + x2 - 11)^2 + (x1 + x2 - 7)^2)
%   f2_max = f1_max(2x1, 2x2)
%   We minimize -f1_max and -f2_max.
%
%   Properties:
%     - convex: yes (negative of concave quadratics)
%     - domain: not specified
%
%   Refactored by: Dr. Mohammed Alshahrani

x1 = x(1); x2 = x(2);
S11 = x1 + x2 - 11; S7 = x1 + x2 - 7;
f1_max = 5 - (S11^2 + S7^2);
S11p = 2*x1 + 2*x2 - 11; S7p = 2*x1 + 2*x2 - 7;
f2_max = 5 - (S11p^2 + S7p^2);
F = [-f1_max; -f2_max];

end

