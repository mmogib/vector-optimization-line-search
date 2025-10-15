function G = slcdt2_g(x)
% slcdt2_g  Gradients for SLCDT2 (legacy P10 mapping), n=10.

x = x(:); n = numel(x);
if n < 10, error('slcdt2_g:dim','SLCDT2 expects n=10'); end

g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);

% f1 grad
g1(1) = 4*(x(1)-1)^3;
g1(2:10) = 2*(x(2:10) - 1);

% f2 grad
g2(1) = 2*(x(1) + 1);
g2(2) = 4*(x(2) + 1)^3;
g2(3:10) = 2*(x(3:10) + 1);

% f3 grad
g3(1) = 2*(x(1) - 1);
g3(2) = 2*(x(2) + 1);
g3(3) = 4*(x(3) - 1)^3;
g3(4) = 2*(x(4) + 1);
g3(5) = 2*(x(5) - 1);
g3(6) = 2*(x(6) + 1);
g3(7) = 2*(x(7) - 1);
g3(8) = 2*(x(8) + 1);
g3(9) = 2*(x(9) - 1);
g3(10)= 2*(x(10) + 1);

G = {g1, g2, g3};

end

