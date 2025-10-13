fprintf('=== Log file created: %s ===\n', fullfile(pwd, 'full_run_log.txt'));

fprintf('=== Run started: %s ===\n', datetime('now'));

try
    setup_()
catch ME
    fprintf('Error caught: %s\n', ME.message);
end

fprintf('=== Run ended: %s ===\n', datetime('now'));


function setup_(varargin)
% setup  Add repository paths (src, problems, experiments, tests) to MATLAB path.
% Usage:
%   setup                % add paths for current session
%   setup persist        % add paths and save permanently (savepath)
%
% Works from any current directory; resolves paths relative to this file.

persist = (nargin >= 1) && any(strcmpi(varargin, 'persist'));

root = fileparts(mfilename('fullpath'));
dirs = {
    fullfile(root, 'src')
    fullfile(root, 'problems')
    fullfile(root, 'experiments')
    fullfile(root, 'tests')
    % fullfile(root,'logs')
};

added = {};
for i = 1:numel(dirs)
    if exist(dirs{i}, 'dir')
        addpath(genpath(dirs{i})); %#ok<*MCAP>
        added{end+1} = dirs{i}; %#ok<AGROW>
    end
end

fprintf('[setup] Added to path:\n');
for i = 1:numel(added)
    fprintf('  - %s\n', added{i});
end

% Check solver availability
if exist('vop_solve', 'file') ~= 2
    warning('[setup] vop_solve not found on path. Check that src/ exists.');
end

% Check Optimization Toolbox (quadprog)
if exist('quadprog','file') ~= 2
    warning(['[setup] quadprog not found. HZ/HZN directions require the ', ...
             'Optimization Toolbox. Install it or replace the QP solver.']);
end

if persist
    try
        status = savepath;
        if status ~= 0
            warning('[setup] savepath failed. Try running MATLAB as administrator.');
        else
            fprintf('[setup] Path saved (persistent).\n');
        end
    catch ME
        warning('[setup] savepath error: %s', ME.message);
    end
end

end