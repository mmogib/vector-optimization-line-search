%% Build and plot performance profiles from fresh runs
% Refactored by: Dr. Mohammed Alshahrani

clear; clc;
logdir = fullfile('../logs'); if ~exist(logdir,'dir'), mkdir(logdir); end
outdir = fullfile('../outputs','performance'); if ~exist(outdir,'dir'), mkdir(outdir); end
logpath = fullfile(logdir, 'perf_profile_log.txt');
if exist(logpath, 'file'); delete(logpath); end; diary(logpath);

addpath(genpath(fullfile('src')));
addpath(genpath(fullfile('problems')));

% Problems (P-set)
reg = registry();
keep = {'IKK1','TE8','MOP5','MOP7','SLCDT2'};
mask = ismember({reg.name}, keep);
problems = {reg(mask).name};

% Methods (columns)
methods = [ ...
  struct('label','HZ+DWOLFE1', 'opts', struct('direction','hz','linesearch','dwolfe1', 'maxIter',300,'tol',1e-8,'gradTol',1e-4,'hz_mu',1,'hz_c',0.2,'hz_ita',1e-2)), ...
  struct('label','PRP+QWOLFE','opts', struct('direction','prp','linesearch','qwolfe',  'maxIter',1000,'tol',1e-8,'gradTol',1e-3,'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3)), ...
  struct('label','SD+QWOLFE', 'opts', struct('direction','sd', 'linesearch','qwolfe',  'maxIter',1000,'tol',1e-8,'gradTol',1e-3,'alphamax',10,'rho',1e-4,'sigma',0.1,'delta',1.3)) ...
];

% Starts and global overrides
starts = 5; baseOpts = struct();

[data, probNames, labels] = collect_performance_data(problems, methods, starts, baseOpts); %#ok<ASGLU>

% Plot
plot_performance_profiles(data, labels);

% Save plots (PNG + FIG) under logs with timestamp
try
  ts = datestr(now, 'yyyymmdd_HHMMSS');
  fh = gcf;
  outPng = fullfile(outdir, sprintf('perf_profiles_%s.png', ts));
  outFig = fullfile(outdir, sprintf('perf_profiles_%s.fig', ts));
  try
    exportgraphics(fh, outPng, 'Resolution', 300);
  catch
    saveas(fh, outPng);
  end
  try, savefig(fh, outFig); catch, end
  fprintf('Saved performance profiles to: %s\n', outPng);
catch ME
  fprintf('WARNING: Failed to save figure: %s\n', ME.message);
end

diary off
