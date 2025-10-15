function G = zlt1_g(x, M)
% zlt1_g  Gradients for ZLT1.
%   G = zlt1_g(x, M) returns 1xM cell array of gradients.

x = x(:);
n = numel(x);
if nargin < 2 || isempty(M), M = 2; end
M = max(1, min(M, n));

G = cell(1, M);
for m = 1:M
  gm = 2*x;              % gradient of sum x_i^2
  idx = min(m, n);
  gm(idx) = 2*(x(idx) - 1); % replace component m: d/dx_m [(x_m-1)^2]
  G{m} = gm;
end

end

