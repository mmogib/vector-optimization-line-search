%% Direction sanity sweep (quick)
% Refactored by: Dr. Mohammed Alshahrani
% Verifies SD, PRP+, and HZ directions run without errors on the P-set.
% Uses minimal restarts and recommended line-search per direction.

clear; clc;
if exist('../logs/dir_sanity_log.txt', 'file'); delete('../logs/dir_sanity_log.txt'); end; diary('../logs/dir_sanity_log.txt');
addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

problems = registry();
keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'};
mask = ismember({problems.name}, keep);
problems = problems(mask);

dirs = {'sd','prp','hz'};
ls_for = struct('sd','qwolfe','prp','qwolfe','hz','dwolfe1');

numStarts = 2; rng(0);

fprintf('Direction sanity start: %s\n', datestr(now));
for ip = 1:numel(problems)
  pname = problems(ip).name; n = problems(ip).n;
  for idr = 1:numel(dirs)
    dname = dirs{idr}; lsname = ls_for.(dname);
    ok = 0; fails = 0;
    for s = 1:numStarts
      x0 = -1 + 2*rand(n,1);
      if ~strcmpi(pname,'IKK1'), x0 = 1.2 * x0; end
      problem = struct('x0', x0, 'name', pname, 'm', 2);
      if strcmpi(dname,'hz')
        opts = struct('direction','hz','linesearch',lsname,'maxIter',200,'tol',1e-8,'gradTol',1e-4, ...
                      'hz_mu',1,'hz_c',0.2,'hz_ita',1e-2);
      else
        opts = struct('direction',dname,'linesearch',lsname,'maxIter',300,'tol',1e-8,'gradTol',1e-3, ...
                      'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3);
      end
      try
        [~, F, info] = vop_solve(problem, opts); %#ok<ASGLU>
        ok = ok + 1;
      catch ME
        fails = fails + 1; %#ok<NASGU>
        fprintf('name=%s %s+%s run=%d: ERROR %s\n', pname, dname, lsname, s, ME.getReport('short','hyperlinks','off'));
      end
    end
    fprintf('name=%s %s+%s: ok=%d/%d\n', pname, dname, lsname, ok, numStarts);
  end
end

fprintf('Direction sanity end: %s\n', datestr(now));
diary off
