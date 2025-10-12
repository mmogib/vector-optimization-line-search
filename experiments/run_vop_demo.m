%% Minimal experiment runner for VOP line-search (m=2)
% Generates a small approximation set via multiple restarts and reports metrics.

clear; clc;
if exist('../full_run_log.txt', 'file'); delete('../full_run_log.txt'); end; diary('../full_run_log.txt');
addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

% Load problem registry for IDs, names, and default dimensions
problems = registry();

numStarts = 5; rng(0);

results = struct('id',{},'name',{},'P',{},'F',{},'runs',{},'hv',{});

for ip = 1:numel(problems)
    pid = problems(ip).id; n = problems(ip).n; pname = problems(ip).name;
    Pcols = []; % columns are objective vectors (M x N)
    for s = 1:numStarts
        x0 = -1 + 2*rand(n,1);
        problem = struct('x0', x0, 'problemId', pid, 'm', 2);
        opts = struct('direction','hz', 'linesearch','dwolfe1', 'maxIter',200, 'tol',1e-8);
        [x, F, info] = vop_solve(problem, opts);
        Pcols = [Pcols, F]; %#ok<AGROW>
        fprintf('pid=%d (%s), run=%d, iters=%d, reason=%s\n', pid, pname, s, info.iters, info.reason);
    end
    % Metrics on the approximation set (self-referenced for demo)
    hv = NaN; pur = NaN; gd = NaN; gd_aux = [];
    try
        if ~isempty(Pcols)
            % Convert to rows = points (N x M) and deduplicate
            Prows = unique(Pcols', 'rows');
            % Hypervolume expects P as [N x M] and F as [M x N]
            hv = hypervolume(Prows, Prows');
            % Purity (self vs self against self)
            try
                pur_vec = purity(Prows, Prows, Prows);
                if ~isempty(pur_vec), pur = pur_vec(1); end
            catch
                % leave as NaN
            end
            % Gamma/Delta (self-set placeholders)
            try
                [gd_vec, gd_aux] = Gamma_Delta(Prows, Prows, Prows, Prows);
                if ~isempty(gd_vec), gd = gd_vec(1); end
            catch
                % leave as NaN
            end
        end
    catch ME
        warning('metrics failed for pid=%d: %s', pid, ME.message);
    end
    results(ip).id = pid; results(ip).name = pname;
    results(ip).P = Pcols; results(ip).F = Pcols; % alias for clarity
    results(ip).runs = numStarts; results(ip).hv = hv; results(ip).purity = pur; results(ip).gamma_delta = gd; results(ip).gamma_delta_aux = gd_aux;
end

disp('Summary (hypervolume over self-set):');
for ip = 1:numel(results)
    fprintf('pid=%d (%s): hv=%.4g, purity=%.4g, gamma-delta=%.4g, runs=%d\n', results(ip).id, results(ip).name, results(ip).hv, results(ip).purity, results(ip).gamma_delta, results(ip).runs);
end

diary off
