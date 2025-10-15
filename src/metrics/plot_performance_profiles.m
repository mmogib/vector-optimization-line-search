function plot_performance_profiles(data, labels, opts)
% plot_performance_profiles  Plot 5 performance profiles from cost tables.
%   plot_performance_profiles(data, labels, opts)
%   Inputs
%     data   Struct with fields (each N x K; rows=problems, cols=methods):
%              - iterations  (optional)
%              - nfev        (optional)
%              - ngev        (optional)
%              - vsd         (optional) vector steepest-descent evals
%              - time        (optional)
%     labels  1 x K cellstr of method names (e.g., {'HZ','PRP+','SD'})
%     opts    Optional struct:
%              - figure   existing figure handle (default: new figure)
%              - tauMax   struct with fields: iterations, nfev, ngev, vsd, time
%                         that set the x-axis max for tau (defaults below)
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 2 || isempty(labels)
  K = infer_K(data);
  labels = arrayfun(@(i) sprintf('m%d',i), 1:K, 'uni',0);
end
if nargin < 3, opts = struct(); end

fh = getfield_def(opts, 'figure', []);
if isempty(fh) || ~ishandle(fh)
  fh = figure('Name','Performance Profiles','Color','w');
end

tauMax = struct('iterations',5, 'nfev',20, 'ngev',7, 'vsd',5, 'time',5);
if isfield(opts, 'tauMax') && ~isempty(opts.tauMax)
  tauMax = merge_struct(tauMax, opts.tauMax);
end

subplot_idx = 1;
subplot(2,3,subplot_idx); subplot_idx = subplot_idx + 1;
if isfield(data,'iterations') && ~isempty(data.iterations)
  plot_performance_profile(data.iterations, labels, gca, '(I) Iterations', tauMax.iterations);
else
  title('(I) Iterations (missing)'); axis off
end

subplot(2,3,subplot_idx); subplot_idx = subplot_idx + 1;
if isfield(data,'nfev') && ~isempty(data.nfev)
  plot_performance_profile(data.nfev, labels, gca, '(II) Function evaluations', tauMax.nfev);
else
  title('(II) Function evaluations (missing)'); axis off
end

subplot(2,3,subplot_idx); subplot_idx = subplot_idx + 1;
if isfield(data,'ngev') && ~isempty(data.ngev)
  plot_performance_profile(data.ngev, labels, gca, '(III) Gradient evaluations', tauMax.ngev);
else
  title('(III) Gradient evaluations (missing)'); axis off
end

subplot(2,3,subplot_idx); subplot_idx = subplot_idx + 1;
if isfield(data,'vsd') && ~isempty(data.vsd)
  plot_performance_profile(data.vsd, labels, gca, '(IV) Vector steepest descent evaluations', tauMax.vsd);
else
  title('(IV) Vector steepest descent evaluations (missing)'); axis off
end

subplot(2,3,subplot_idx);
if isfield(data,'time') && ~isempty(data.time)
  plot_performance_profile(data.time, labels, gca, '(V) CPU time', tauMax.time);
else
  title('(V) CPU time (missing)'); axis off
end

end

function K = infer_K(data)
% infer_K  Guess method count from first non-empty field
fields = {'iterations','nfev','ngev','vsd','time'};
for i=1:numel(fields)
  f = fields{i};
  if isfield(data,f) && ~isempty(data.(f))
    K = size(data.(f),2); return
  end
end
K = 0;
end

function out = merge_struct(a, b)
out = a; fn = fieldnames(b);
for i=1:numel(fn)
  out.(fn{i}) = b.(fn{i});
end
end

function v = getfield_def(s, name, default)
if isstruct(s) && isfield(s,name) && ~isempty(s.(name))
  v = s.(name);
else
  v = default;
end
end

