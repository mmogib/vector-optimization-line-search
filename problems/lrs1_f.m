function F = lrs1_f(x)
% lrs1_f  LRS1 two-objective test [LRS2000].
%   f1(x1) = x1 + 1
%   f2(x1,x2) = x1^2 + 2 + x2^2 / x1
%
%   Properties:
%     - convex: no (x2^2/x1 is not convex over R; convex only on x1>0)
%     - domain: x_i in [-50, 50]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2, error('lrs1_f:dim','LRS1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

F = [x1 + 1; x1^2 + 2 + (x2^2) / x1];

end

