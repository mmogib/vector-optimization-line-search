%% Minimal experiment runner for VOP line-search (m=2)
% Generates a small approximation set via multiple restarts and reports metrics.

clear; clc;
if exist('../full_run_log.txt', 'file'); delete('../full_run_log.txt'); end; diary('../full_run_log.txt');
addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

% Toggle recommended settings (sd+qwolfe) vs baseline (hz+dwolfe1)
if ~exist('useRecommended','var'); useRecommended = true; end

% Load problem registry for IDs, names, and default dimensions
problems = registry();

numStarts = 5; rng(0);

results = struct('id',{},'name',{},'P',{},'F',{},'runs',{},'hv',{});

for ip = 1:numel(problems)
    pid = problems(ip).id; n = problems(ip).n; pname = problems(ip).name;
    Pcols = []; iters_list = []; % columns are objective vectors (M x N)
    for s = 1:numStarts
        x0 = -1 + 2*rand(n,1);
        problem = struct('x0', x0, 'problemId', pid, 'm', 2);
        if useRecommended
            opts = struct('direction','sd', 'linesearch','qwolfe', 'maxIter',200, 'tol',1e-8);
        else
            opts = struct('direction','hz', 'linesearch','dwolfe1', 'maxIter',200, 'tol',1e-8);
        end
        [x, F, info] = vop_solve(problem, opts);
        Pcols = [Pcols, F]; %#ok<AGROW>
        iters_list(end+1) = info.iters; %#ok<AGROW>
        fprintf('pid=%d (%s), run=%d, iters=%d, reason=%s\n', pid, pname, s, info.iters, info.reason);
    end
    % Metrics on the approximation set (self-referenced for demo)
    hv = NaN; pur = NaN; gd = NaN;
    if ~isempty(Pcols)
        Prows = unique(Pcols', 'rows');
        % Build a small reference front (optional)
        useReference = true; refStarts = 5;
        if useReference
            baseProb = struct('x0', zeros(n,1), 'problemId', pid, 'm', 2);
            Pref = build_reference_front(baseProb, struct('direction','sd','linesearch','qwolfe','maxIter',200,'tol',1e-8), refStarts);
        else
            Pref = [];
        end
        m = compute_metrics(Prows, Pref);
        hv = m.hv; pur = m.purity; gd = m.gamma_delta;
    end
    results(ip).id = pid; results(ip).name = pname;
    results(ip).P = Pcols; results(ip).F = Pcols; % alias for clarity
    results(ip).runs = numStarts; results(ip).hv = hv; results(ip).purity = pur; results(ip).gamma_delta = gd; results(ip).avg_iters = mean(iters_list);
end

disp('Summary (with approximate reference front):');
for ip = 1:numel(results)
    fprintf('pid=%d (%s): hv=%.4g, purity=%.4g, gamma-delta=%.4g, avg-iters=%.2f, runs=%d\n', results(ip).id, results(ip).name, results(ip).hv, results(ip).purity, results(ip).gamma_delta, results(ip).avg_iters, results(ip).runs);
end

diary off
