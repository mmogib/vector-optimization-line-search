function [d, state] = direction_prp(x, grad, history, opts)
% direction_prp  Polak–Ribière-Plus nonlinear CG direction.
%   [d, state] = direction_prp(x, grad, history, opts)
%   Expects history.grad_prev and history.d_prev if available.
%   Falls back to steepest descent on first iteration.

if nargin < 2
    error('direction_prp:NotEnoughInputs', 'Requires at least x and grad.');
end

beta = 0;
if nargin >= 3 && isstruct(history) && isfield(history,'grad_prev') && ~isempty(history.grad_prev)
    g = grad(:); gp = history.grad_prev(:);
    y = g - gp;
    denom = gp' * gp;
    if denom > 0
        beta_raw = (g' * y) / denom;
        beta = max(0, beta_raw); % PRP+
    end
end

if beta > 0 && isfield(history,'d_prev') && ~isempty(history.d_prev)
    d = -grad + beta * history.d_prev;
else
    d = -grad;
end

state = struct('name','prp+','beta',beta);

