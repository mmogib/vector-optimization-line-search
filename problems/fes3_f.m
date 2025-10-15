function F = fes3_f(x)
% fes3_f  FES3 four-objective test (per user definitions).
%   f1 = sum_{i=1..n} | x_i - exp((i/n)^2)/3 |^{0.5}
%   f2 = sum_{i=1..n} | x_i - (sin(i-1)*cos(i-1))^2 |^{0.5}
%   f3 = sum_{i=1..n} | x_i - 0.25*cos(i-1)*cos(2*i-2) - 0.5 |^{0.5}
%   f4 = sum_{i=1..n} ( x_i - 0.5*sin(1000*pi/n) - 0.5 )^2

x = x(:);
n = numel(x);
i = (1:n)';

target1 = exp((i./n).^2) / 3;
f1 = sum( abs(x - target1).^0.5 );
target2 = (sin(i-1).*cos(i-1)).^2;
f2 = sum( abs(x - target2).^0.5 );
target3 = 0.25*cos(i-1).*cos(2*i-2) + 0.5;
f3 = sum( abs(x - target3).^0.5 );
f4 = sum( ( x - 0.5*sin(1000*pi*i/n) - 0.5 ).^2 );

F = [f1; f2; f3; f4];

%   Properties:
%     - convex: no (includes sqrt-absolute terms)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

end

