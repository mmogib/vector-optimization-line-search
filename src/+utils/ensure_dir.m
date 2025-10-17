function ensure_dir(d)
% utils.ensure_dir  Create directory if it does not exist.
if ~exist(d, 'dir')
  mkdir(d);
end
end

