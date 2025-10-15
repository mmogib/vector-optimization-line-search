function F = zlt1_f(x, M)
% zlt1_f  ZLT1 M-objective quadratic separable problem.
%   F = zlt1_f(x, M)
%   fm(x) = (x_m - 1)^2 + sum_{i!=m} x_i^2, m=1..M
%   Domain: x_i in [-1000, 1000]

x = x(:);
n = numel(x);
if nargin < 2 || isempty(M), M = 2; end
M = max(1, min(M, n));

F = zeros(M,1);
sx2 = sum(x.^2);
for m = 1:M
  xm = x(min(m,n));
  F(m) = (xm - 1)^2 + (sx2 - xm^2);
end

end

