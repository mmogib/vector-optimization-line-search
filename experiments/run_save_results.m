%% Run vop_solve across problems/initial points and save results to CSV (versioned)
% Refactored by: Dr. Mohammed Alshahrani

clear; clc;
outdir = fullfile('../outputs','runs'); if ~exist(outdir,'dir'), mkdir(outdir); end
logdir = fullfile('../logs'); if ~exist(logdir,'dir'), mkdir(logdir); end
diary(fullfile(logdir,'save_results_log.txt'));

addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

% Problems (P-set)
reg = registry();
if evalin('base','exist(''problems'',''var'')')
  userList = evalin('base','problems');
  if iscell(userList) && ~isempty(userList)
    mask = ismember({reg.name}, userList);
    reg = reg(mask);
  else
    keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'}; mask = ismember({reg.name}, keep); reg = reg(mask);
  end
else
  keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'}; mask = ismember({reg.name}, keep); reg = reg(mask);
end

% Methods (direction + linesearch; labels built downstream from fields)
methods = [ ...
  struct('direction','hz','linesearch','dwolfe1', 'opts', struct('maxIter',300,'tol',1e-8,'gradTol',1e-4,'hz_mu',1,'hz_c',0.2,'hz_ita',1e-2)), ...
  struct('direction','prp','linesearch','qwolfe',  'opts', struct('maxIter',1000,'tol',1e-8,'gradTol',1e-3,'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3)), ...
  struct('direction','sd', 'linesearch','qwolfe',  'opts', struct('maxIter',1000,'tol',1e-8,'gradTol',1e-3,'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3)) ...
];

% Restarts
starts = 5; rng(0);

% Progress tracking (console)
T = numel(reg) * numel(methods) * starts; c = 0; tStart = tic;
fprintf('Progress: %3.0f%% [%d/%d] Elapsed 00:00 ETA --:--\r', 0, 0, T);

% Prepare CSV file (versioned names results_vN.csv and results_latest.csv)
[csvPath, latestPath] = next_version_paths(outdir, 'results');
fid = fopen(csvPath, 'w');
if fid < 0, error('Could not open %s for writing', csvPath); end

% Header
cols = {'problem','n','init_id','direction','linesearch', ...
        'iterations','ls_internal_iters','dir_internal_iters', ...
        'nfev','ngev','cpu_time_sec','success','reason', ...
        'maxIter','tol','gradTol','alphamax','rho','sigma','delta','hz_mu','hz_c','hz_ita'};
fprintf(fid, '%s\n', strjoin(cols, ','));

for ip = 1:numel(reg)
  name = reg(ip).name; n = reg(ip).n;
  for m = 1:numel(methods)
    base = methods(m);
    for s = 1:starts
      x0 = -1 + 2*rand(n,1);
      problem = struct('x0', x0, 'name', name, 'm', 2);
      % Merge opts with direction/linesearch
      opts = base.opts; opts.direction = base.direction; opts.linesearch = base.linesearch;
      % CPU time
      t0 = cputime;
      success = 0; reason = '';
      iters = NaN; nfev = NaN; ngev = NaN; cpu_time = NaN;
      try
        [~, ~, info] = vop_solve(problem, opts);
        cpu_time = cputime - t0;
        iters = utils.getfield_def(info,'iters',NaN);
        lsi   = utils.getfield_def(info,'ls_internal_iters',NaN);
        diri  = utils.getfield_def(info,'dir_internal_iters',NaN);
        nfev  = utils.getfield_def(info,'nf',NaN);
        ngev  = utils.getfield_def(info,'ng',NaN);
        success = 1; reason = utils.getfield_def(info,'reason','');
      catch ME
        cpu_time = cputime - t0;
        reason = ME.message;
      end
      row = {name, n, s, base.direction, base.linesearch, ...
             iters, lsi, diri, ...
             nfev, ngev, cpu_time, success, reason, ...
             getf(opts,'maxIter'), getf(opts,'tol'), getf(opts,'gradTol'), getf(opts,'alphamax'), ...
             getf(opts,'rho'), getf(opts,'sigma'), getf(opts,'delta'), getf(opts,'hz_mu'), getf(opts,'hz_c'), getf(opts,'hz_ita')};
      write_row(fid, row);
      % Update progress
      c = c + 1;
      elapsed = toc(tStart);
      pct = 100 * c / T;
      if c > 0, eta = (elapsed / c) * (T - c); else, eta = NaN; end
      fprintf('Progress: %3.0f%% [%d/%d] Elapsed %s ETA %s\r', pct, c, T, utils.format_duration(elapsed), utils.format_duration(eta));
    end
  end
end

fclose(fid);

% Update latest copy
try
  copyfile(csvPath, latestPath);
catch
end

fprintf('Saved results to: %s\n', csvPath);
fprintf('\n'); % end progress line
diary off

function [csvPath, latestPath] = next_version_paths(dirPath, base)
% Get next versioned filename and latest alias path
files = dir(fullfile(dirPath, sprintf('%s_v*.csv', base))); nums = 0;
for i=1:numel(files)
  m = regexp(files(i).name, [base '_v(\d+)\.csv$'], 'tokens');
  if ~isempty(m), nums = max(nums, str2double(m{1}{1})); end
end
v = nums + 1;
csvPath = fullfile(dirPath, sprintf('%s_v%d.csv', base, v));
latestPath = fullfile(dirPath, sprintf('%s_latest.csv', base));
end

% (time_fmt replaced by utils.format_duration)

function v = getf(s, name)
if isfield(s, name) && ~(numel(s.(name))==0)
  v = s.(name);
else
  v = NaN;
end
end

function write_row(fid, row)
% Write CSV row with minimal escaping for commas
for i = 1:numel(row)
  val = row{i};
  if ischar(val) || isstring(val)
    txt = char(val);
    txt = strrep(txt, '"', '""');
    fprintf(fid, '"%s"', txt);
  elseif isnumeric(val) && isscalar(val)
    if isnan(val)
      fprintf(fid, '');
    else
      fprintf(fid, '%g', val);
    end
  else
    fprintf(fid, '');
  end
  if i < numel(row), fprintf(fid, ','); end
end
fprintf(fid, '\n');
end

% (getfield_def replaced by utils.getfield_def)
