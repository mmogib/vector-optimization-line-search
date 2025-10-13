%% Parameter sweep for directions and line-search strategies (m=2)
% Logs summary metrics per (problem, direction, linesearch).

clear; clc;
if exist('../logs/sweep_log.txt', 'file'); delete('../logs/sweep_log.txt'); end; diary('../logs/sweep_log.txt');

addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

problems = registry();
dirs = {'hz','sd','prp'}; % hz requires quadprog
lss  = {'dwolfe1','dwolfe2','qwolfe'};
numStarts = 3; rng(0);

fprintf('Sweep start: %s\n', datestr(now));
for ip = 1:numel(problems)
    pid = problems(ip).id; n = problems(ip).n; pname = problems(ip).name;
    for idr = 1:numel(dirs)
        for ils = 1:numel(lss)
            dirName = dirs{idr}; lsName = lss{ils};
            Pcols = [];
            for s = 1:numStarts
                x0 = -1 + 2*rand(n,1);
                problem = struct('x0', x0, 'problemId', pid, 'm', 2);
                opts = struct('direction',dirName, 'linesearch',lsName, 'maxIter',200, 'tol',1e-8);
                try
                    [x, F, info] = vop_solve(problem, opts); %#ok<ASGLU>
                    Pcols = [Pcols, F]; %#ok<AGROW>
                catch ME
                    fprintf('pid=%d(%s) %s+%s: ERROR %s\n', pid, pname, dirName, lsName, ME.message);
                end
            end
            if ~isempty(Pcols)
                Prows = unique(Pcols', 'rows');
                m = compute_metrics(Prows);
                fprintf('pid=%d(%s) %s+%s: hv=%.4g pur=%.4g gd=%.4g (N=%d)\n', pid, pname, dirName, lsName, m.hv, m.purity, m.gamma_delta, size(Prows,1));
            else
                fprintf('pid=%d(%s) %s+%s: no points\n', pid, pname, dirName, lsName);
            end
        end
    end
end

fprintf('Sweep end: %s\n', datestr(now));
diary off

