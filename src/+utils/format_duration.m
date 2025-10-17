function s = format_duration(t)
% utils.format_duration  Convert seconds into M:SS or H:MM:SS.
%   Returns '--:--' for invalid inputs.

if ~isfinite(t) || t < 0
  s = '--:--';
  return;
end
if t < 3600
  m = floor(t/60); ss = floor(mod(t,60));
  s = sprintf('%d:%02d', m, ss);
else
  h = floor(t/3600); m = floor(mod(t,3600)/60); ss = floor(mod(t,60));
  s = sprintf('%d:%02d:%02d', h, m, ss);
end

end

