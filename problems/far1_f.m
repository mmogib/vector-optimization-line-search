function F = far1_f(x)
% far1_f  Far1 two-objective landscape test.
%   Domain: x_i in [-1, 1]

if numel(x) < 2, error('far1_f:dim','Far1 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);

% Define helper for Gaussian-like bumps
E = @(K,a,b) exp(K*(-(x1-a)^2 - (x2-b)^2));

% f1 per table
F1 = -2*E(15, 0.1, 0.0) ...
     -1*E(20, 0.6, 0.6) ...
     +1*E(20, 0.6,-0.6) ...
     +1*E(20,-0.6, 0.6) ...
     +1*E(20,-0.6,-0.6);

% f2 per table
F2 = +2*E(20, 0.2, 0.0) ...
     +1*E(20, 0.4, 0.6) ...
     -1*E(20, 0.5, 0.7) ...
     -1*E(20, 0.5,-0.7) ...
     +1*E(20, 0.4,-0.8);

F = [F1; F2];

end

