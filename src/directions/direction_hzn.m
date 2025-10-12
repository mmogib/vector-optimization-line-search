function [d, state] = direction_hzn(x, grad, history, opts)
% direction_hzn  HZN direction using quadratic subproblem (initial step).
%   [d, state] = direction_hzn(x, grad, history, opts)
%   Computes v by solving the HZ subproblem and returns d = v.
%   Adaptive update rules will be added when step-coupling is integrated.

if nargin < 4 || isempty(opts), opts = struct(); end
probId = getfielddef(opts,'problemId',1);
r1     = getfielddef(opts,'r1',1);
r2     = getfielddef(opts,'r2',1);

[v, fval, out] = hz_subproblem(x, probId, r1, r2);
d = v;
state = struct('name','hzn','fval',fval,'qp_exitflag',out.exitflag);

end

function v = getfielddef(s, name, default)
if isfield(s, name) && ~isempty(s.(name))
    v = s.(name);
else
    v = default;
end
end
