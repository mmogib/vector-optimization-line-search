function F = tkly1_f(x)
% tkly1_f  TKLY1 two-objective test.
%   f1 = x1
%   f2 = x1 * prod_{i=2..4} [ 2.0 - exp(-((x_i-0.1)/0.04)^2) - 0.8*exp(-((x_i-0.9)/0.4)^2) ]
%   Domain: x1 in [0.1,1], x2..x4 in [0,1]

x = x(:);
if numel(x) < 4, error('tkly1_f:dim','TKLY1 expects at least 4 variables'); end

x1 = x(1);
P = ones(3,1);
for k = 2:4
  a = (x(k) - 0.1)/0.04;
  b = (x(k) - 0.9)/0.4;
  P(k-1) = 2.0 - exp(-a^2) - 0.8*exp(-b^2);
end
prodP = prod(P);

f1 = x1;
f2 = x1 * prodP;
F = [f1; f2];

end

