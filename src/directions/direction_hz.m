function [d, state] = direction_hz(x, grad, history, opts)
% direction_hz  HZ direction with adaptive update (betaki).
%   [d, state] = direction_hz(x, grad, history, opts)
%   - Solves the HZ quadratic subproblem to get v at x, then updates
%     the next direction using betaki with safeguards.
%   - Expects opts.name|problemId and r1,r2 (for m=2) and optionally opts.params.
%   - Defaults: hz_mu=1, hz_c=0.2, hz_ita=1e-2 (documented and used).
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 4 || (numel(opts)==0), opts = struct(); end

% Problem key and params
if isfield(opts,'name') && ~(numel(opts.name)==0)
    key = opts.name;
elseif isfield(opts,'problemId')
    key = opts.problemId;
else
    error('direction_hz:BadProblem','Provide opts.name or opts.problemId');
end
params = getfielddef(opts,'params', struct());

r1 = getfielddef(opts,'r1',1);
r2 = getfielddef(opts,'r2',1);

% HZ parameters
mu  = getfielddef(opts,'hz_mu',1);
c   = getfielddef(opts,'hz_c',0.2);
ita = getfielddef(opts,'hz_ita',1e-2);

% Compute v at x
[v, fxkivki, out] = hz_subproblem(x, key, r1, r2, params);

% Default direction is v (first iteration)
d = v;

% Current grads via dispatcher (needed for state even on first iter)
[~, Gfun] = problem_dispatcher(key, 2, params);
grads_cur = Gfun(x);

% Adaptive update if we have previous state (robust to path shadowing)
hasPrev = false; v_prev = []; d_prev = []; grads_prev = []; fxkvk_prev = [];
try
    v_prev = history.v_prev; d_prev = history.d_prev;
    grads_prev = history.grads_prev; fxkvk_prev = history.fxkvk_prev;
    hasPrev = (numel(v_prev) ~= 0) && (numel(d_prev) ~= 0) && (numel(grads_prev) ~= 0);
catch
    hasPrev = false;
end

if hasPrev
    % grads_prev must be interpretable by local_maxphi (cell or numeric)

    % Helper for max weighted directional derivative (accept cell or numeric)
    maxphi = @(gc, dir) local_maxphi(gc, dir, r1, r2);

    fxkdk  = maxphi(grads_prev, d_prev);
    fxkvki = maxphi(grads_prev, v);   % prev grads with current v
    p = -fxkivki + fxkvki;

    fxkidk = maxphi(grads_cur, d_prev);
    fxkivk = maxphi(grads_cur, v_prev);
    q = fxkivk - fxkvk_prev;
    denom = fxkidk - fxkdk;
    if ~isfinite(denom) || abs(denom) < 1e-14
        betakiHZ = 0;
    else
        betakiHZ = (1/denom) * (p - mu*fxkidk*((p+q)/denom));
    end
    itak = -1/(norm(d_prev) * min(ita, norm(v_prev)) + eps);
    betaki = max(betakiHZ, itak);
    d_next = v + betaki * d_prev;

    % Acceptance test and adjustment
    fxkidki = maxphi(grads_cur, d_next);
    if fxkidki > c * fxkivki && betaki < 0
        h = maxphi(grads_cur, -d_prev);
        if h > 0
            betaki = (1 - c) * fxkivki / h;
        else
            betaki = 0;
        end
        d_next = v + betaki * d_prev;
    end

    d = d_next;
end

% Package state and persistent history for next iteration
% Capture internal counts: hz_subproblem evaluates gradients once; count as 1 Gfun call
dir_ng = 1;
dir_nf = 0;
dir_iters = 1;
try
    if isstruct(out) && isfield(out,'output') && isstruct(out.output) && isfield(out.output,'iterations')
        dir_iters = out.output.iterations;
    end
catch
end

state = struct('name','hz','fval',fxkivki,'qp_exitflag',out.exitflag, 'nf',dir_nf,'ng',dir_ng,'iters',dir_iters);
state.history = struct('v_prev', v, 'd_prev', d, 'grads_prev', grads_cur, 'fxkvk_prev', fxkivki);

end

function v = getfielddef(s, name, default)
if isstruct(s) && isfield(s, name)
    val = s.(name);
    if ~(numel(val) == 0)
        v = val;
        return
    end
end
v = default;
end

function val = local_maxphi(gc, dir, r1, r2)
% local_maxphi  Max weighted directional derivative for m=2 (no iscell)
    g1 = []; g2 = [];
    try
        % Try cell indexing first
        g1 = gc{1}; g2 = gc{2};
    catch
        % Fall back to numeric matrix/vector
        try
            if size(gc,2) >= 2
                g1 = gc(:,1); g2 = gc(:,2);
            else
                g1 = gc; g2 = gc;
            end
        catch
            % Last resort: zeros
            g1 = zeros(size(dir)); g2 = zeros(size(dir));
        end
    end
    val = max([r1*(g1(:)'*dir(:)), r2*(g2(:)'*dir(:))]);
end
