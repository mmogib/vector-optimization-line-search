function F = dgo2_f(x)
% dgo2_f  DGO2 one-dimensional two-objective problem.
%   F = dgo2_f(x)
%   f1(x) = x^2
%   f2(x) = 9 - sqrt(81 - x^2)
%   Domain: x in [-9, 9]

if isempty(x), error('dgo2_f:dim','Input x must be non-empty'); end
xi = x(1);
rad = 81 - xi^2;
if rad < 0
  f2 = Inf; % outside domain, penalize
else
  f2 = 9 - sqrt(rad);
end
F = [xi^2; f2];

end

