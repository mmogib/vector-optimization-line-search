function F = fes2_f(x)
% fes2_f  FES2 three-objective test (per user definitions).
%   f1 = sum_{i=1..n} ( x_i - 0.5*cos(10*pi*i/n) - 0.5 )^2
%   f2 = sum_{i=1..n} | x_i - (sin(i-1)*cos(i-1))^2 |^{0.5}
%   f3 = sum_{i=1..n} | x_i - 0.25*cos(i-1)*cos(2*i-2) - 0.5 |^{0.5}

x = x(:);
n = numel(x);
i = (1:n)';

f1 = sum( ( x - 0.5*cos(10*pi*i/n) - 0.5 ).^2 );
target2 = (sin(i-1).*cos(i-1)).^2;
f2 = sum( abs(x - target2).^0.5 );
target3 = 0.25*cos(i-1).*cos(2*i-2) + 0.5;
f3 = sum( abs(x - target3).^0.5 );

F = [f1; f2; f3];

%   Properties:
%     - convex: no (sqrt-absolute terms are nonconvex)
%     - domain: x_i in [0, 1]
%
%   Refactored by: Dr. Mohammed Alshahrani

end

