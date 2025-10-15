function F = mop7_f(x)
% mop7_f  MOP7 three-objective test (legacy P6 mapping).
%   f1 = (x1-2)^2/2 + (x2+1)^2/13 + 3
%   f2 = (x1+x2-3)^2/36 + (-x1+x2+2)^2/8 - 17
%   f3 = (x1+2*x2-1)^2/175 + (-x1+2*x2)^2/17 - 13

x = x(:);
if numel(x) < 2, error('mop7_f:dim','MOP7 expects at least 2 variables'); end
x1 = x(1); x2 = x(2);
f1 = (x1-2)^2/2 + (x2+1)^2/13 + 3;
f2 = (x1+x2-3)^2/36 + (-x1+x2+2)^2/8 - 17;
f3 = (x1+2*x2-1)^2/175 + (-x1+2*x2)^2/17 - 13;
F = [f1; f2; f3];

end

