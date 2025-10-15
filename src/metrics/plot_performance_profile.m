function plot_performance_profile(costs, labels, ax, titleStr, xMax)
% plot_performance_profile  Plot a Dolan–Moré style performance profile.
%   plot_performance_profile(costs, labels, ax, titleStr, xMax)
%   - costs: N x K matrix of positive costs (rows = problems, cols = methods)
%   - labels: 1 x K cellstr of method labels
%   - ax: target axes handle (optional; uses gca if omitted)
%   - titleStr: title string (optional)
%   - xMax: x-axis upper bound for tau (optional)
%   Refactored by: Dr. Mohammed Alshahrani

if nargin < 2 || isempty(labels), labels = arrayfun(@(i) sprintf('m%d',i), 1:size(costs,2), 'uni',0); end
if nargin < 3 || isempty(ax), ax = gca; end
if nargin < 4, titleStr = ''; end
if nargin < 5 || isempty(xMax), xMax = 10; end

axes(ax); hold(ax, 'on');

% Normalize by per-row min (ratios >= 1)
K = size(costs,2);
rat = costs;
mins = nanmin(rat, [], 2);
mins(mins==0) = eps;
rat = rat ./ mins;

% Build performance profile for each method
cols = [0.49 0.18 0.56; 0.93 0.69 0.13; 0 0.4470 0.7410; 0.85 0.33 0.10; 0.3 0.75 0.93];
ls   = {'-.','-.','-.','-','-'};

for i = 1:K
  r = rat(:,i);
  % Treat NaNs as +Inf so they never count as covered
  r(~isfinite(r)) = inf;
  a = unique(r(isfinite(r)));
  if numel(a) < 2, a = [1; max(1,max(r))]; end
  e = zeros(1, numel(a)-1);
  for k = 2:numel(a)
    e(k-1) = mean(r <= a(k));
  end
  x = a(2:end);
  y = e;
  ci = cols(1+mod(i-1,size(cols,1)),:);
  li = ls{1+mod(i-1,numel(ls))};
  plot(ax, x, y, li, 'Color', ci, 'LineWidth', 2);
end

axis(ax, [1 xMax 0 1]);
xlabel(ax, '\tau'); ylabel(ax, '\rho(\tau)');
if ~isempty(titleStr), title(ax, titleStr, 'FontName','Times New Roman','Color','k','FontSize',13); end
legend(ax, labels{:});

end
