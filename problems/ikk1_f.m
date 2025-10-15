function F = ikk1_f(x)
% ikk1_f  IKK1 three-objective test (legacy P1 mapping).
%   F = ikk1_f(x) returns [x1^2; (x1-20)^2; x2^2]

x = x(:);
if numel(x) < 2, error('ikk1_f:dim','IKK1 expects at least 2 variables'); end
F = [x(1)^2; (x(1)-20)^2; x(2)^2];

end

