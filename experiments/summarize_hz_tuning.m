function S = summarize_hz_tuning(logPath)
% summarize_hz_tuning  Summarize best HZ params (qwolfe) per problem from log.
%   S = summarize_hz_tuning('logs/hz_tuning_log.txt') returns a struct array
%   with fields: pid, name, base_hv, base_avg, best_hv, best_avg, mu, c, ita, delta_hv.

if nargin < 1 || isempty(logPath)
  logPath = fullfile('logs','hz_tuning_log.txt');
end
txt = fileread(logPath);
lines = regexp(txt, '\r?\n', 'split');

base = containers.Map('KeyType','double','ValueType','any');
best = containers.Map('KeyType','double','ValueType','any');
names = containers.Map('KeyType','double','ValueType','char');

for i = 1:numel(lines)
  L = strtrim(lines{i});
  m = regexp(L, 'pid=(\d+)\(([^\)]+)\)\s+qwolfe BASE:\s+hv=([0-9.eE+-]+)\s+avg-iters=([0-9.eE+-]+)', 'tokens');
  if ~isempty(m)
    t = m{1}; pid = str2double(t{1}); names(pid) = t{2};
    base(pid) = struct('hv', str2double(t{3}), 'avg', str2double(t{4}));
    continue
  end
  m = regexp(L, 'pid=(\d+)\(([^\)]+)\)\s+qwolfe\s+mu=([0-9.eE+-]+)\s+c=([0-9.eE+-]+)\s+ita=([0-9.eE+-]+):\s+hv=([0-9.eE+-]+).*?avg=([0-9.eE+-]+)', 'tokens');
  if ~isempty(m)
    t = m{1}; pid = str2double(t{1}); names(pid) = t{2};
    mu = str2double(t{3}); c = str2double(t{4}); ita = str2double(t{5});
    hv = str2double(t{6}); avg = str2double(t{7});
    if ~best.isKey(pid) || hv > best(pid).hv
      best(pid) = struct('mu',mu,'c',c,'ita',ita,'hv',hv,'avg',avg);
    end
  end
end

pids = sort(cell2mat(keys(names)));
S = struct('pid',{},'name',{},'base_hv',{},'base_avg',{},'best_hv',{},'best_avg',{},'mu',{},'c',{},'ita',{},'delta_hv',{});
for k = 1:numel(pids)
  pid = pids(k); name = names(pid);
  b = struct('hv',NaN,'avg',NaN); if base.isKey(pid), b = base(pid); end
  r = struct('mu',NaN,'c',NaN,'ita',NaN,'hv',NaN,'avg',NaN); if best.isKey(pid), r = best(pid); end
  S(k).pid = pid; S(k).name = name;
  S(k).base_hv = b.hv; S(k).base_avg = b.avg;
  S(k).best_hv = r.hv; S(k).best_avg = r.avg;
  S(k).mu = r.mu; S(k).c = r.c; S(k).ita = r.ita;
  S(k).delta_hv = r.hv - b.hv;
end

% Pretty print
fprintf('Best HZ (qwolfe) per problem:\n');
for k = 1:numel(S)
  s = S(k);
  fprintf('  pid=%d(%s): base hv=%.4g avg=%.2f | best hv=%.4g avg=%.2f with mu=%.3g c=%.3g ita=%.1e (Δhv=%.4g)\n', ...
    s.pid, s.name, s.base_hv, s.base_avg, s.best_hv, s.best_avg, s.mu, s.c, s.ita, s.delta_hv);
end

end

