function F = mhhm1_f(x)
% mhhm1_f  MHHM1 three-objective scalar variable test [MHHM1999].
%
%   Properties:
%     - convex: yes (sum of convex quadratics)
%     - domain: x in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

xi = x(1);
F = [(xi-0.8)^2; (xi-0.85)^2; (xi-0.9)^2];

end
