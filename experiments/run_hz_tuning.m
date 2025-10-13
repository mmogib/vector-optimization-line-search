%% HZ parameter tuning sweep for m=2
% Sweeps over hz_mu, hz_c, hz_ita and Wolfe constants (rhoba=c1, sigmaba=c2).
% Logs hv and avg iters deltas vs baseline per (problem, linesearch).

clear; clc;
logdir = fullfile('../logs'); if ~exist(logdir,'dir'), mkdir(logdir); end
logpath = fullfile(logdir, 'hz_tuning_log.txt');
if exist(logpath, 'file'); delete(logpath); end; diary(logpath);

addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

problems = registry();

% Grids
hz_mu_grid  = [0.5, 1, 2];
hz_c_grid   = [0.1, 0.2, 0.4];
hz_ita_grid = [1e-3, 1e-2, 1e-1];

% Wolfe constants: rhoba ~ c1, sigmaba ~ c2
c1_grid = [1e-4, 1e-3];
c2_grid = [0.5, 0.9];

lss = {'dwolfe1','dwolfe2','qwolfe'};
numStarts = 3; rng(0);

fprintf('HZ tuning start: %s\n', datestr(now));

for ip = 1:numel(problems)
    pid = problems(ip).id; n = problems(ip).n; pname = problems(ip).name;
    for ils = 1:numel(lss)
        lsName = lss{ils};

        % Baseline with default HZ params and default Wolfe constants
        base_opts = struct('direction','hz', 'linesearch',lsName, 'maxIter',200, 'tol',1e-8);
        if any(strcmp(lsName, {'dwolfe1','dwolfe2'}))
            % Defaults in wrappers: rhoba=1e-4, sigmaba=0.9
        end
        [base_hv, base_avg] = eval_cfg(pid, n, base_opts, numStarts);
        fprintf('pid=%d(%s) %s BASE: hv=%.4g avg-iters=%.2f\n', pid, pname, lsName, base_hv, base_avg);

        for mu = hz_mu_grid
            for cc = hz_c_grid
                for ita = hz_ita_grid
                    if any(strcmp(lsName, {'dwolfe1','dwolfe2'}))
                        for c1 = c1_grid
                            for c2 = c2_grid
                                tun_opts = base_opts;
                                tun_opts.hz_mu = mu; tun_opts.hz_c = cc; tun_opts.hz_ita = ita;
                                tun_opts.rhoba = c1; tun_opts.sigmaba = c2;
                                [hv, avg] = eval_cfg(pid, n, tun_opts, numStarts);
                                fprintf('pid=%d(%s) %s mu=%.2g c=%.2g ita=%.1e c1=%.0e c2=%.1f: hv=%.4g (d=%.4g) avg=%.2f (d=%.2f)\n', ...
                                    pid, pname, lsName, mu, cc, ita, c1, c2, hv, hv-base_hv, avg, avg-base_avg);
                            end
                        end
                    else
                        tun_opts = base_opts;
                        tun_opts.hz_mu = mu; tun_opts.hz_c = cc; tun_opts.hz_ita = ita;
                        [hv, avg] = eval_cfg(pid, n, tun_opts, numStarts);
                        fprintf('pid=%d(%s) %s mu=%.2g c=%.2g ita=%.1e: hv=%.4g (d=%.4g) avg=%.2f (d=%.2f)\n', ...
                            pid, pname, lsName, mu, cc, ita, hv, hv-base_hv, avg, avg-base_avg);
                    end
                end
            end
        end
    end
end

fprintf('HZ tuning end: %s\n', datestr(now));
diary off

function [hv, avg_iters] = eval_cfg(pid, n, opts, numStarts)
% Helper to run numStarts restarts and compute hv and avg iters
    Pcols = []; iters_list = [];
    for s = 1:numStarts
        x0 = -1 + 2*rand(n,1);
        problem = struct('x0', x0, 'problemId', pid, 'm', 2);
        try
            [x, F, info] = vop_solve(problem, opts); %#ok<ASGLU>
            Pcols = [Pcols, F]; %#ok<AGROW>
            iters_list(end+1) = info.iters; %#ok<AGROW>
        catch
            % Skip failures
        end
    end
    if isempty(Pcols)
        hv = NaN; avg_iters = NaN; return;
    end
    Prows = unique(Pcols', 'rows');
    m = compute_metrics(Prows);
    hv = m.hv;
    if isempty(iters_list), avg_iters = NaN; else, avg_iters = mean(iters_list); end
end

