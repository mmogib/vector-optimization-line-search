%% Parameter sweep for directions and line-search strategies (m=2)
% Refactored by: Dr. Mohammed Alshahrani
% Logs summary metrics per (problem, direction, linesearch).

clear; clc;
if exist('../logs/sweep_log.txt', 'file'); delete('../logs/sweep_log.txt'); end; diary('../logs/sweep_log.txt');

addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

problems = registry();
% Allow user override: `problems = {'IKK1','TE8'}` in caller workspace
if evalin('base','exist(''problems'',''var'')')
  userList = evalin('base','problems');
  if iscell(userList) && ~isempty(userList)
    mask = ismember({problems.name}, userList);
    problems = problems(mask);
  end
else
  keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'};
  mask = ismember({problems.name}, keep);
  problems = problems(mask);
end
% Focus on recommended combo: sd + qwolfe
dirs = {'sd'};
lss  = {'qwolfe'};
numStarts = 3; rng(0);

fprintf('Sweep start: %s\n', datestr(now));
for ip = 1:numel(problems)
    pname = problems(ip).name; n = problems(ip).n;
    % Choose linesearch set
    lss_loc = lss;
    % Per-problem restarts
    if strcmpi(pname,'IKK1'), numStarts_loc = numStarts; else, numStarts_loc = 5; end
    for idr = 1:numel(dirs)
        for ils = 1:numel(lss_loc)
            dirName = dirs{idr}; lsName = lss_loc{ils};
            Pcols = [];
            for s = 1:numStarts_loc
                x0 = -1 + 2*rand(n,1);
                if ~strcmpi(pname,'IKK1'), x0 = 1.5 * x0; end % diversify starts
                problem = struct('x0', x0, 'name', pname, 'm', 2);
                % Tuned sd + qwolfe options
                opts = struct('direction',dirName,'linesearch',lsName, ...
                              'maxIter',1000, 'tol',1e-8, 'gradTol',1e-3, ...
                              'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3);
                try
                    [x, F, info] = vop_solve(problem, opts); %#ok<ASGLU>
                    Pcols = [Pcols, F]; %#ok<AGROW>
                catch ME
                    fprintf('name=%s %s+%s: ERROR %s\n', pname, dirName, lsName, ME.getReport('extended','hyperlinks','off'));
                end
            end
            if ~isempty(Pcols)
                Prows = unique(Pcols', 'rows');
                m = compute_metrics(Prows);
                hv_s  = fmt(m.hv);
                pur_s = fmt(m.purity);
                gd_s  = fmt(m.gamma_delta);
                fprintf('name=%s %s+%s: hv=%s pur=%s gd=%s (N=%d)\n', pname, dirName, lsName, hv_s, pur_s, gd_s, size(Prows,1));
            else
                fprintf('name=%s %s+%s: no points\n', pname, dirName, lsName);
            end
        end
    end
end

fprintf('Sweep end: %s\n', datestr(now));
diary off

function s = fmt(v)
% fmt  Format metric avoiding Inf/NaN surprises for tiny sets
    if isempty(v) || ~isfinite(v)
        s = 'NA';
    else
        s = sprintf('%.4g', v);
    end
end
