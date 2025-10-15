function G = im1_g(x)
% im1_g  Gradients for IM1 two-objective problem [IM1998].
%   G = im1_g(x) returns {g1, g2} gradients.
%
%   Properties:
%     - convex: no
%     - domain: x1 in [1, 4], x2 in [1, 2]
%
%   Refactored by: Dr. Mohammed Alshahrani

n = numel(x);
if n < 2, error('im1_g:dim','IM1 expects at least 2 decision variables'); end

g1 = zeros(n,1); g2 = zeros(n,1);

% f1 = 2*sqrt(x1), df1/dx1 = 1/sqrt(x1)
epsx = 1e-12;
x1 = max(x(1), epsx);
g1(1) = 1/sqrt(x1);

% f2 = x1*(1 - x2) + 5
g2(1) = 1 - x(2);
g2(2) = -x(1);

G = {g1, g2};

end
