function F = mlf1_f(x)
% mlf1_f  MLF1 two-objective single-variable test [MLF1994].
%   f1 = (1 + x/20)*sin x
%   f2 = (1 + x/20)*cos x
%
%   Properties:
%     - convex: no (trigonometric terms)
%     - domain: x in [0, 20]
%
%   Refactored by: Dr. Mohammed Alshahrani
%   Reference: S. Huband, P. Hingston, L. Barone, L. While, A review of multiobjective test problems and a scalable test problem toolkit. IEEE Transactions on Evolutionary Computation, 10(5)(2006) 477-506.

xi = x(1);
amp = 1 + xi/20;
F = [amp * sin(xi); amp * cos(xi)];

end



