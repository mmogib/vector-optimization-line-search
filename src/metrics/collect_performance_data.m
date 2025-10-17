function [data, probNames, labels] = collect_performance_data(problemNames, methods, starts, baseOpts)
% collect_performance_data  Build performance tables from fresh runs.
%   [data, probNames, labels] = collect_performance_data(problemNames, methods, starts, baseOpts)
%   - problemNames: cellstr of problem names present in registry()
%   - methods: struct array with fields:
%       - label    : string label for plots
%       - opts     : struct with direction/linesearch and solver options
%   - starts: integer number of random restarts per problem (>=1)
%   - baseOpts: additional opts merged into each method.opts (optional)
%   Returns:
%     data: struct of N x K matrices (rows = problems, cols = methods)
%           with fields: iterations, nfev, ngev, time (vsd omitted)
%     probNames: 1 x N cellstr of problem names used
%     labels: 1 x K cellstr of method labels
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 4, baseOpts = struct(); end
if nargin < 3 || starts < 1, starts = 3; end

labels = {methods.label};

% Load registry and filter
reg = registry();
mask = ismember(upper({reg.name}), upper(problemNames));
reg = reg(mask);
N = numel(reg); K = numel(methods);
probNames = {reg.name};

% Hold per-problem median stats
iters = NaN(N, K);
nfev  = NaN(N, K);
ngev  = NaN(N, K);
tm    = NaN(N, K);

rng(0);
for ip = 1:N
  n = reg(ip).n; name = reg(ip).name;
  for k = 1:K
    ms = methods(k);
    % Merge base opts last to not override method-required fields
    opts = merge_opts(ms.opts, baseOpts);
    vals_iters = NaN(starts,1);
    vals_nfev  = NaN(starts,1);
    vals_ngev  = NaN(starts,1);
    vals_time  = NaN(starts,1);
    for s = 1:starts
      x0 = -1 + 2*rand(n,1);
      problem = struct('x0', x0, 'name', name, 'm', 2);
      t0 = tic;
      try
        [~, ~, info] = vop_solve(problem, opts);
        vals_time(s)  = toc(t0);
        vals_iters(s) = utils.getfield_def(info, 'iters', NaN);
        vals_nfev(s)  = utils.getfield_def(info, 'nf', NaN);
        vals_ngev(s)  = utils.getfield_def(info, 'ng', NaN);
      catch
        vals_time(s)  = toc(t0);
      end
    end
    iters(ip,k) = median(vals_iters);
    nfev(ip,k)  = median(vals_nfev);
    ngev(ip,k)  = median(vals_ngev);
    tm(ip,k)    = median(vals_time);
  end
end

data = struct('iterations', iters, 'nfev', nfev, 'ngev', ngev, 'time', tm);

end

function out = merge_opts(a, b)
% merge_opts  Shallow merge of structs, fields in b override a
out = a;
if ~isstruct(b) || isempty(b), return; end
fn = fieldnames(b);
for i=1:numel(fn)
  out.(fn{i}) = b.(fn{i});
end
end

% (getfield_def replaced by utils.getfield_def)

