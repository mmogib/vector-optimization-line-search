%% Plot performance profiles from a versioned CSV (latest or chosen vN)
% Refactored by: Dr. Mohammed Alshahrani

clear; clc;
addpath(genpath(fullfile('src')));

runDir = fullfile('../outputs','runs');
perfDir = fullfile('../outputs','performance'); if ~exist(perfDir,'dir'), mkdir(perfDir); end

% Pick CSV file: prefer results_latest.csv, fallback to highest vN
csvLatest = fullfile(runDir, 'results_latest.csv');
if exist(csvLatest,'file')
  csvPath = csvLatest;
else
  files = dir(fullfile(runDir,'results_v*.csv'));
  if isempty(files), error('No results CSV found in %s', runDir); end
  nums = arrayfun(@(f) sscanf(f.name,'results_v%d.csv'), files);
  [~,idx] = max(nums); csvPath = fullfile(runDir, files(idx).name);
end

% Load and plot
[data, labels, problems] = load_performance_from_csv(csvPath); %#ok<ASGLU>
plot_performance_profiles(data, labels);

% Save plots
fh = gcf;
ts = datestr(now,'yyyymmdd_HHMMSS');
[~, csvBase, ~] = fileparts(csvPath);
outStem = sprintf('perf_profiles_from_%s_%s', csvBase, ts);
outPng = fullfile(perfDir, [outStem '.png']);
outFig = fullfile(perfDir, [outStem '.fig']);
try
  exportgraphics(fh, outPng, 'Resolution', 300);
catch
  saveas(fh, outPng);
end
try, savefig(fh, outFig); catch, end
fprintf('Plotted from %s -> %s\n', csvPath, outPng);
