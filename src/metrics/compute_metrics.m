function out = compute_metrics(Prows, Pref)
% compute_metrics  Compute hv, purity, gamma-delta with safe guards.
%   Prows: N x M (rows = points, cols = objectives)
%   Pref (optional): reference front rows (rows=points, cols=objectives)
%   Returns struct with fields: hv, purity, gamma_delta

out = struct('hv', NaN, 'purity', NaN, 'gamma_delta', NaN);

if nargin < 1 || isempty(Prows) || size(Prows,2) < 2
    return
end

% Deduplicate
Prows = unique(Prows, 'rows');

if nargin < 2 || isempty(Pref)
    Pref = Prows;
else
    Pref = unique(Pref, 'rows');
end

% Hypervolume expects P [N x M] and F [M x N]
try
    out.hv = hypervolume(Prows, Pref');
catch
    % leave as NaN
end

% Purity and Gamma-Delta (use self-set as placeholder reference)
try
    pv = purity(Prows, Prows, Pref);
    if ~isempty(pv)
        out.purity = pv(1);
    end
catch
    % leave as NaN
end

try
    [gdv, ~] = Gamma_Delta(Prows, Prows, Pref, Pref);
    if ~isempty(gdv)
        out.gamma_delta = gdv(1);
    end
catch
    % leave as NaN
end

end
