function G = dpam1_g(x, params)
% dpam1_g  Gradients for DPAM1 with rotation.
%   G = dpam1_g(x, params)
%   See dpam1_f for definitions.

if nargin < 2 || ~isfield(params,'R') || isempty(params.R)
  R = eye(numel(x));
else
  R = params.R;
end

y = R * x(:);
n = numel(y);

% Compute g and its gradient w.r.t y
g = 1 + 10*(n-1) + sum(y(2:n).^2 - 10*cos(4*pi*y(2:n)));
dg = zeros(n,1);
dg(1) = 0;
for i = 2:n
  dg(i) = 2*y(i) + 40*pi*sin(4*pi*y(i));
end

% Gradients w.r.t y
g1_y = zeros(n,1); g1_y(1) = 1;

% f2 = g * exp(-y1/g)
f2_y = zeros(n,1);
f2_y(1) = -exp(-y(1)/g);
coeff = exp(-y(1)/g) * (1 + y(1)/g);
for i = 2:n
  f2_y(i) = coeff * dg(i);
end

% Chain rule: grad_x = R' * grad_y
G = {R' * g1_y, R' * f2_y};

end

