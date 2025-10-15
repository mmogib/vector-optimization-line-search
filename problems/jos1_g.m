function G = jos1_g(x)
% jos1_g  Gradients for JOS1 [JOS1995].
%
%   Properties:
%     - convex: yes
%     - domain: x in R^n (not specified)
%
%   Refactored by: Dr. Mohammed Alshahrani

x = x(:); n = numel(x); idx = (1:n)';
g1 = 2 * (idx .* x);
g2 = 2 * (x - 2) / max(n,1);
G = {g1, g2};

end
