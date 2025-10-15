function F = dpam1_f(x, params)
% dpam1_f  DPAM1 two-objective problem with rotation.
%   F = dpam1_f(x, params)
%   - params.R: rotation matrix (n x n). If absent, identity is used.
%   y = R x; g = 1 + 10(n-1) + sum_{i=2..n} [y_i^2 - 10 cos(4 pi y_i)]
%   f1(y) = y1
%   f2(y) = g * exp(-y1/g)
%   Domain: x_i in [-0.3, 0.3]

if nargin < 2 || ~isfield(params,'R') || isempty(params.R)
  R = eye(numel(x));
else
  R = params.R;
end

y = R * x(:);
n = numel(y);
g = 1 + 10*(n-1) + sum(y(2:n).^2 - 10*cos(4*pi*y(2:n)));
f1 = y(1);
f2 = g * exp(-y(1)/g);
F = [f1; f2];

end

