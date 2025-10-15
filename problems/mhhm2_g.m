function G = mhhm2_g(x)
% mhhm2_g  Gradients for MHHM2.

n = numel(x); x1 = x(1); x2 = x(2);
g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);

g1(1) = 2*(x1-0.8);  g1(2) = 2*(x2-0.6);
g2(1) = 2*(x1-0.85); g2(2) = 2*(x2-0.7);
g3(1) = 2*(x1-0.9);  g3(2) = 2*(x2-0.6);

G = {g1, g2, g3};

end

