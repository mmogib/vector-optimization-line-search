function F = mhhm2_f(x)
% mhhm2_f  MHHM2 three-objective two-variable test [MHHM1999].
%
%   Properties:
%     - convex: yes (sum of convex quadratics)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

x1 = x(1); x2 = x(2);
F = [ (x1-0.8)^2 + (x2-0.6)^2; ...
      (x1-0.85)^2 + (x2-0.7)^2; ...
      (x1-0.9)^2 + (x2-0.6)^2 ];

end


