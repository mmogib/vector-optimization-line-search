function run_linesearch_compare()
% run_linesearch_compare  Compare line-searches with a fixed direction.
%   Selects 10 problems and solves each 100 times from random starts
%   sampled uniformly from the problem domain. Reports iterations (iters),
%   function evals (nf), and gradient evals (ng) per method.
%
%   Defaults:
%     - direction: 'sd' (fixed)
%     - linesearches: {'qwolfe','dwolfe'}
%     - starts: 100
%     - problems: a 10-problem set with known domains
%
%   Outputs:
%     - Prints a summary table (medians) to console.
%     - Writes a CSV to outputs/runs/ with per-run records.
%     - Console progress: percentage, count, elapsed, ETA (single line).
%
%   Refactored by: Dr. Mohammed Alshahrani

utils.setup_if_needed();

% Configuration
direction = 'sd';
linesearches = {'qwolfe','dwolfe'};
starts = 100;

% Problem selection (10 with explicit domains in refs/problems.tex)
if evalin('base','exist(''problems'',''var'')')
  problems = evalin('base','problems');
else
  problems = {'BK1' ,'DGO1','DGO2','IM1','Kur1', ...
               'LTDZ1','MLF1','SP1','SSFYY1','VU2'};
end

% Registry lookup
reg = registry();
name2meta = containers.Map(upper({reg.name}), num2cell(1:numel(reg)));

rng(0);

% Pre-allocate results storage (grows per-run rows)
rows = {};
totalRuns = numel(problems) * starts * numel(linesearches);
kdone = 0; t0 = tic; utils.progress_update(kdone, totalRuns, t0, true);

for ip = 1:numel(problems)
  pname = problems{ip};
  if ~name2meta.isKey(upper(pname))
    error('Unknown problem %s in registry()', pname);
  end
  pm = reg(name2meta(upper(pname)));
  n = pm.n; m = pm.m;

  % Domain bounds
  [lb, ub] = local_bounds(pname, n);

  for s = 1:starts
    x0 = lb + (ub - lb) .* rand(n,1);
    if strcmpi(pname,'LRS1')
      % guard division by zero in x1
      if abs(x0(1)) < 1e-8, x0(1) = sign(x0(1)+eps) * 1e-2; end
    end

    for il = 1:numel(linesearches)
      ls = linesearches{il};
      problem = struct('x0', x0, 'problemId', pname, 'm', m);
      opts = struct('maxIter', 500, 'tol', 1e-8, ...
                    'direction', direction, 'linesearch', ls);
      try
        tstart = tic;
        [~, ~, info] = vop_solve(problem, opts);
        cpu_time_sec = toc(tstart);
      catch ME
        info = struct('iters', NaN, 'nf', NaN, 'ng', NaN, ...
                      'reason', sprintf('error:%s', ME.identifier));
        cpu_time_sec = NaN;
      end
      success = ~(isnan(utils.getfield_def(info,'iters',NaN)) || startsWith(utils.getfield_def(info,'reason',''), 'error:'));
      rows(end+1,:) = {pname, n, m, direction, ls, s, ...
                       utils.getfield_def(info,'iters',NaN), ...
                       utils.getfield_def(info,'ls_internal_iters',NaN), ...
                       utils.getfield_def(info,'dir_internal_iters',NaN), ...
                       utils.getfield_def(info,'nf',NaN), ...
                       utils.getfield_def(info,'ng',NaN), cpu_time_sec, double(success), ...
                       utils.getfield_def(info,'reason','')}; %#ok<AGROW>
      kdone = kdone + 1; utils.progress_update(kdone, totalRuns, t0, false);
    end
  end
end
utils.progress_update(0, 0, t0, 'finalize'); % finish progress line

% Convert to table and write CSV
T = cell2table(rows, 'VariableNames', {'problem','n','m','direction','linesearch', ...
                                       'start','iterations','ls_internal_iters','dir_internal_iters', ...
                                       'nfev','ngev','cpu_time_sec','success','reason'});
outdir = fullfile('..','outputs','runs'); if ~exist(outdir,'dir'), mkdir(outdir); end
ts = datetime("now",'Format','yyyyMMdd_HHmmss');
outfile = fullfile(outdir, sprintf('linesearch_compare_%s.csv', ts));

writetable(T, outfile);
fprintf('Saved per-run results to %s\n', outfile);

% Print summary (median per problem x method)
methods = linesearches;
fprintf('\nMedian results by problem (direction=%s):\n', direction);
for ip = 1:numel(problems)
  pname = problems{ip};
  fprintf('  %s\n', pname);
  for il = 1:numel(methods)
    ls = methods{il};
    mask = strcmp(T.problem, pname) & strcmp(T.linesearch, ls) & T.success==1;
    it = median(T.iterations(mask),'omitnan');
    nf = median(T.nfev(mask),'omitnan');
    ng = median(T.ngev(mask),'omitnan');
    fprintf('    - %-8s  it=%-6.1f  nf=%-6.1f  ng=%-6.1f\n', ls, it, nf, ng);
  end
end

% Build and save performance profiles from this CSV
try
  [pdata, plabels, ~] = load_performance_from_csv(outfile);
  pfdir = fullfile('outputs','performance'); if ~exist(pfdir,'dir'), mkdir(pfdir); end
  fh = figure('Visible','off');
  plot_performance_profiles(pdata, plabels, struct('figure', fh));
  saveas(fh, fullfile(pfdir, sprintf('linesearch_compare_%s.png', ts)));
  close(fh);
  fprintf('Saved performance profiles to %s\n', pfdir);
catch ME
  fprintf('Could not generate performance profiles: %s\n', ME.message);
end

end

function [lb, ub] = local_bounds(name, n)
% local_bounds  Lower/upper bounds from refs/problems.tex (subset).
name = upper(string(name));
switch name
  case 'BK1',     lb = -5*ones(n,1);    ub = 10*ones(n,1);
  case 'DGO1',    lb = -10*ones(n,1);   ub = 13*ones(n,1);
  case 'DGO2',    lb = -9*ones(n,1);    ub = 9*ones(n,1);
  case 'IM1',     lb = [1;1];           ub = [4;2];
  case 'KUR1',    lb = -5*ones(n,1);    ub = 5*ones(n,1);
  case 'LTDZ1',   lb = zeros(n,1);      ub = ones(n,1);
  case 'MLF1',    lb = 0*ones(n,1);     ub = 20*ones(n,1);
  case 'SP1',     lb = -100*ones(n,1);  ub = 100*ones(n,1);
  case 'SSFYY1',  lb = -100*ones(n,1);  ub = 100*ones(n,1);
  case 'VU2',     lb = -3*ones(n,1);    ub = 3*ones(n,1);
  otherwise
    error('local_bounds:Unknown', 'No bounds for %s; add mapping.', name);
end
end

% (local utility functions moved to utils package)
