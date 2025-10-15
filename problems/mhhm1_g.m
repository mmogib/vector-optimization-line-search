function G = mhhm1_g(x)
% mhhm1_g  Gradients for MHHM1.

n = numel(x); xi = x(1);
g1 = zeros(n,1); g2 = zeros(n,1); g3 = zeros(n,1);
g1(1) = 2*(xi-0.8);
g2(1) = 2*(xi-0.85);
g3(1) = 2*(xi-0.9);
G = {g1, g2, g3};

end

