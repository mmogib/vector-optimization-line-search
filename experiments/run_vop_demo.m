%% Minimal experiment runner for VOP line-search (m=2)
% Refactored by: Dr. Mohammed Alshahrani
% Generates a small approximation set via multiple restarts and reports metrics.

clear; clc;
if exist('../logs/demo_log.txt', 'file'); delete('../logs/demo_log.txt'); end; diary('../logs/demo_log.txt');
addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

% Toggle recommended settings (sd+qwolfe) vs baseline (hz+dwolfe1)
if ~exist('useRecommended','var'); useRecommended = true; end
% Optional HV booster: record intermediate objective vectors every K iters
if ~exist('hvBoost','var'); hvBoost = true; end
if ~exist('recordEvery','var'); recordEvery = 5; end

% Load problem registry for IDs, names, and default dimensions
problems = registry();
% Restrict to P1/P2/P5/P6/P10 equivalents: IKK1, TE8, MOP5, MOP7, SLCDT2
keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'};
mask = ismember({problems.name}, keep);
problems = problems(mask);

baseStarts = 5; rng(0);

results = struct('id',{},'name',{},'P',{},'F',{},'runs',{},'hv',{});

for ip = 1:numel(problems)
    pname = problems(ip).name; n = problems(ip).n;
    Pcols = []; iters_list = []; % columns are objective vectors (M x N)
    % Per-problem restarts: more for TE8/MOP5/MOP7/SLCDT2
    if ismember(upper(pname), {'TE8','MOP5','MOP7','SLCDT2'})
        numStarts_loc = 8;
    else
        numStarts_loc = baseStarts;
    end
    X0s = zeros(n, numStarts_loc);
    for s = 1:numStarts_loc
        x0 = -1 + 2*rand(n,1);
        if ismember(upper(pname), {'TE8','MOP5','MOP7','SLCDT2'})
            x0 = 1.5 * x0; % mild scaling to diversify starts
        end
        X0s(:,s) = x0;
        problem = struct('x0', x0, 'name', pname, 'm', 2);
        % Choose config: recommended sd+qwolfe or baseline hz+dwolfe1
        if useRecommended
            % Tuned sd + qwolfe for better convergence
            opts = struct('direction','sd','linesearch','qwolfe', ...
                          'maxIter',1000,'tol',1e-8,'gradTol',1e-3, ...
                          'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3);
        else
            opts = struct('direction','hz','linesearch','dwolfe1', ...
                          'maxIter',300,'tol',1e-8,'gradTol',1e-4, ...
                          'hz_mu',1,'hz_c',0.2,'hz_ita',1e-2);
        end
        if hvBoost, opts.recordIntermediateEvery = recordEvery; end
        try
            [x, F, info] = vop_solve(problem, opts); %#ok<ASGLU>
            % Collect final and optional intermediate points
            Pcols = [Pcols, F]; %#ok<AGROW>
            if hvBoost && isfield(info,'intermediateF') && ~(numel(info.intermediateF)==0)
                Pcols = [Pcols, info.intermediateF]; %#ok<AGROW>
            end
            iters_list(end+1) = info.iters; %#ok<AGROW>
            fprintf('name=%s, run=%d, iters=%d, reason=%s\n', pname, s, info.iters, info.reason);
        catch ME
            iters_list(end+1) = NaN; %#ok<AGROW>
            fprintf('name=%s, run=%d: ERROR %s\n', pname, s, ME.getReport('extended','hyperlinks','off'));
        end
    end
    % Metrics on the approximation set (self-referenced for demo)
    hv = NaN; pur = NaN; gd = NaN;
    if ~isempty(Pcols)
        Prows = unique(Pcols', 'rows');
        % Build a small reference front (optional)
        useReference = true; refStarts = 5;
        if useReference
            baseProb = struct('x0', zeros(n,1), 'name', pname, 'm', 2);
            % Seed reference with the same starts for overlap, plus extras
            ropts = opts;
            ropts.cache = false; ropts.x0_list = X0s; ropts.seed = 1;
            Pref = build_reference_front(baseProb, ropts, refStarts);
        else
            Pref = [];
        end
        m = compute_metrics(Prows, Pref);
    hv = m.hv; pur = m.purity; gd = m.gamma_delta;
    end
    results(ip).name = pname;
    results(ip).P = Pcols; results(ip).F = Pcols; % alias for clarity
    results(ip).runs = numStarts_loc; results(ip).hv = hv; results(ip).purity = pur; results(ip).gamma_delta = gd; results(ip).avg_iters = mean(iters_list);
end

disp('Summary (with approximate reference front):');
for ip = 1:numel(results)
    hv_s  = fmt(results(ip).hv);
    pur_s = fmt(results(ip).purity);
    gd_s  = fmt(results(ip).gamma_delta);
    fprintf('name=%s: hv=%s, purity=%s, gamma-delta=%s, avg-iters=%.2f, runs=%d\n', results(ip).name, hv_s, pur_s, gd_s, results(ip).avg_iters, results(ip).runs);
end

function s = fmt(v)
% fmt  Format metric avoiding Inf/NaN surprises for tiny sets
    if (numel(v)==0) || ~isfinite(v)
        s = 'NA';
    else
        s = sprintf('%.4g', v);
    end
end

diary off
