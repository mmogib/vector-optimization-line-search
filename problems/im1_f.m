function F = im1_f(x)
% im1_f  IM1 two-objective problem [IM1998].
%   F = im1_f(x)
%   - x: decision vector (uses first 2 components)
%   - F: 2x1 objective vector [f1; f2] (minimize)
%
%   Definitions:
%     f1(x1)    = 2*sqrt(x1)
%     f2(x1,x2) = x1*(1 - x2) + 5
%
%   Properties:
%     - convex: no
%     - domain: x1 in [1, 4], x2 in [1, 2]
%
%   Refactored by: Dr. Mohammed Alshahrani

if numel(x) < 2
  error('im1_f:dim','IM1 expects at least 2 decision variables');
end

x1 = x(1); x2 = x(2);
f1 = 2*sqrt(max(x1, 0));
f2 = x1*(1 - x2) + 5;
F = [f1; f2];

end
