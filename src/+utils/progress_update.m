function progress_update(k, total, t0, mode)
% utils.progress_update  In-place console progress with ETA.
%   utils.progress_update(k, total, t0, true)   % initialize
%   utils.progress_update(k, total, t0, false)  % update
%   utils.progress_update(0, 0, t0, 'finalize') % finalize line

  persistent lastLen
  if isempty(lastLen), lastLen = 0; end

  if (islogical(mode) && mode) || (ischar(mode) && strcmpi(mode,'first'))
    if lastLen > 0
      fprintf(repmat('\b',1,lastLen));
      lastLen = 0;
    end
    msg = sprintf('Progress:   0.0%% (0/%d)   Elapsed 0s   ETA --:--', total);
    fprintf('%s', msg);
    lastLen = length(msg);
    drawnow limitrate;
    return
  end

  if ischar(mode) && strcmpi(mode,'finalize')
    if lastLen > 0
      fprintf('\n');
      lastLen = 0;
    end
    return
  end

  elapsed = toc(t0);
  if k <= 0
    eta = NaN;
  else
    rate = elapsed / max(k, eps);
    eta = rate * max(total - k, 0);
  end
  prc = 100 * k / max(total,1);
  msg = sprintf('Progress: %5.1f%% (%d/%d)   Elapsed %s   ETA %s', ...
                prc, k, total, utils.format_duration(elapsed), utils.format_duration(eta));
  if lastLen > 0
    fprintf(repmat('\b',1,lastLen));
  end
  fprintf('%s', msg);
  lastLen = length(msg);
  drawnow limitrate;
end

