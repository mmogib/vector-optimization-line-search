function [d, state] = direction_prp(x, grad, history, opts)
% direction_prp  Polak–Ribiere-Plus (PRP+) nonlinear CG direction.
%   [d, state] = direction_prp(x, grad, history, opts)
%   Uses history.grad_prev and history.d_prev when available; otherwise
%   falls back to steepest descent on the first iteration.
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 2
    error('direction_prp:NotEnoughInputs', 'Requires at least x and grad.');
end

beta = 0;
if nargin >= 3 && isstruct(history) && isfield(history,'grad_prev') && ~(numel(history.grad_prev)==0)
    g = grad(:); gp = history.grad_prev(:);
    y = g - gp;
    denom = gp' * gp;
    if denom > 0
        beta_raw = (g' * y) / denom;
        beta = max(0, beta_raw); % PRP+
    end
end

% Optional restart if previous direction is non-descent
restart = false;
if nargin >= 4 && isstruct(opts) && isfield(opts, 'prp_restart') && ~(numel(opts.prp_restart)==0)
    if logical(opts.prp_restart)
        if isfield(history,'d_prev') && ~(numel(history.d_prev)==0)
            restart = (grad(:)' * history.d_prev(:)) >= 0;
        end
    end
end

% Beta capping (PRP+ nicety)
beta_cap = 10;
if nargin >= 4 && isstruct(opts) && isfield(opts,'prp_beta_cap') && ~(numel(opts.prp_beta_cap)==0)
    beta_cap = opts.prp_beta_cap;
end
beta = min(beta, beta_cap);

if restart || ~isfield(history,'d_prev') || (numel(history.d_prev)==0) || beta == 0
    d = -grad;
else
    d = -grad + beta * history.d_prev;
end

state = struct('name','prp+','beta',beta,'restarted',logical(restart), 'iters',1,'nf',0,'ng',0);
