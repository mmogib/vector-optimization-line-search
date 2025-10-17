function make_log(f, filename)
% utils.make_log  Run a function while logging its console output to logs/.
%   utils.make_log(@() my_runner(), 'my_log.txt')
%   - Ensures the repository's root logs/ directory exists and writes the
%     diary there regardless of the current working directory.
%   - Overwrites an existing log file of the same name.
%
%   Inputs
%     f        Function handle with no inputs (e.g., @() run_experiment())
%     filename Log filename (e.g., 'run_vop_sweep.txt')
%
%   Behavior
%     - Creates <repo>/logs if missing.
%     - Writes diary to <repo>/logs/<filename> during f() execution.
%     - Always turns diary off even if f() errors.
%
%   Example
%     utils.make_log(@() run('experiments/run_vop_demo.m'), 'demo_log.txt');
  clc;
  narginchk(2,2);
  if ~isa(f, 'function_handle')
    error('utils.make_log:InvalidInput', 'First argument must be a function handle.');
  end
  if ~(ischar(filename) || isstring(filename)) || strlength(string(filename))==0
    error('utils.make_log:InvalidInput', 'Second argument must be a non-empty filename.');
  end

  % Resolve repo root from this package location: src/+utils/ -> src -> repo
  repoRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
  logdir = fullfile(repoRoot, 'logs');
  utils.ensure_dir(logdir);
  logpath = fullfile(logdir, char(filename));

  % Prepare log
  if exist(logpath, 'file')
    delete(logpath);
  end
  % Ensure no prior diary is active, then start
  diary off;
  diary(logpath);
  c = onCleanup(@() diary('off'));

  % Optional header
  fprintf('=== Log started: %s ===\n', datetime("now"));
  fprintf('[utils.make_log] Writing to: %s\n', logpath);

  % Execute user function
  f();

  fprintf('=== Log ended: %s ===\n', datetime("now"));
end
