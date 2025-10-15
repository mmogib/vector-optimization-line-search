function [data, labels, problems] = load_performance_from_csv(csvPath)
% load_performance_from_csv  Aggregate CSV runs to profile-ready matrices.
%   [data, labels, problems] = load_performance_from_csv(csvPath)
%   - csvPath: path to results CSV (from run_save_results)
%   Returns:
%     data: struct with fields iterations, nfev, ngev, time (N x K)
%     labels: 1 x K method labels as '<direction> + <linesearch>'
%     problems: N x 2 cell array of {problemName, n}
%   Notes:
%   - Groups by problem(n) and method (direction+linesearch)
%   - Uses median across init_id, ignores failures (success=0)
%   Refactored by: Dr. Mohammed Alshahrani

T = readtable(csvPath, 'TextType','string');

% Create problem keys and method labels
T.problem = string(T.problem);
T.key = T.problem + ":n=" + string(T.n);
T.method = string(T.direction) + " + " + string(T.linesearch);

% Get unique problems and methods (ordered)
pkeys = unique(T.key, 'stable');
meths = unique(T.method, 'stable');
N = numel(pkeys); K = numel(meths);

labels = cellstr(meths');
problems = cell(N,2);
for i=1:N
  parts = split(pkeys(i), ":n=");
  problems{i,1} = parts(1); problems{i,2} = str2double(parts(2));
end

% Initialize matrices
iters = NaN(N,K); nfev = NaN(N,K); ngev = NaN(N,K); tm = NaN(N,K);

for i=1:N
  for j=1:K
    mask = T.key==pkeys(i) & T.method==meths(j) & T.success==1;
    if any(mask)
      iters(i,j) = nanmedian(T.iterations(mask));
      nfev(i,j)  = nanmedian(T.nfev(mask));
      ngev(i,j)  = nanmedian(T.ngev(mask));
      tm(i,j)    = nanmedian(T.cpu_time_sec(mask));
    end
  end
end

data = struct('iterations', iters, 'nfev', nfev, 'ngev', ngev, 'time', tm);

end

