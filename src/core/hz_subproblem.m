function [v, fval, out] = hz_subproblem(x, problemId, r1, r2)
% hz_subproblem  Solve HZ/HZN quadratic subproblem to get v-direction.
%   [v, fval, out] = hz_subproblem(x, problemId, r1, r2)
%   Solves:
%     min  e1' * z  subject to  -z1 + r1*g1(x,problemId)'*z2..n+1 <= 0
%                                  -z1 + r2*g2(x,problemId)'*z2..n+1 <= 0
%   where z = [z1; v], returning v and objective value fval.

if nargin < 4, error('hz_subproblem:NotEnoughInputs','Need x, problemId, r1, r2'); end
% Use unified dispatcher for gradients
[~, Gfun] = problem_dispatcher(problemId, 2);
Gs = Gfun(x);
g1x = Gs{1};
g2x = Gs{2};
n = numel(x);

% Fallback if gradients contain non-finite values
if any(~isfinite(g1x)) || any(~isfinite(g2x))
    gsum = r1*safevec(g1x) + r2*safevec(g2x);
    v = -gsum;
    fval = NaN;
    out = struct('exitflag',-3,'output','nonfinite gradients');
    return
end

H = zeros(n+1, n+1);
H(2:n+1,2:n+1) = eye(n);
f = zeros(n+1,1); f(1) = 1;
A = [-1, r1*g1x(:)';
     -1, r2*g2x(:)'];
b = zeros(2,1);

try
    % Call quadprog without an initial point to avoid warnings
    options = optimoptions('quadprog','Display',0);
  
    [z, fval, exitflag, output] = quadprog(H, f, A, b, [], [], [], [],[],options);
catch ME
    % Fallback to weighted negative gradient
    gsum = r1*safevec(g1x) + r2*safevec(g2x);
    v = -gsum;
    fval = NaN;
    out = struct('exitflag',-4,'output',ME.message);
    return
end

if exitflag <= 0
    % Still return best effort
    out = struct('exitflag',exitflag,'output',output);
else
    out = struct('exitflag',exitflag,'output',output);
end

v = z(2:end);

end

function y = safevec(y)
%SAFEVEC Replace non-finite entries with zeros
    y(~isfinite(y)) = 0;
end
