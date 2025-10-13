function Pref = build_reference_front(problem, opts, starts)
% build_reference_front  Minimal reference front via multi-start solve + nondomination.
%   Pref: rows (points) x objectives (M)
%   Caches to problems/ref/ by (problemId, n, direction, linesearch, starts).

if nargin < 3 || isempty(starts), starts = 5; end
if nargin < 2 || isempty(opts), opts = struct(); end

% Recommended defaults if not set
if ~isfield(opts,'direction'), opts.direction = 'sd'; end
if ~isfield(opts,'linesearch'), opts.linesearch = 'qwolfe'; end
if ~isfield(opts,'maxIter'), opts.maxIter = 200; end
if ~isfield(opts,'tol'), opts.tol = 1e-8; end
useCache = true; if isfield(opts,'cache'), useCache = logical(opts.cache); end
% If explicit starts are provided, skip cache by default (unless forced)
if isfield(opts,'x0_list') && ~isfield(opts,'cache')
    useCache = false;
end

% Resolve problems/ref directory via registry's location
refDir = [];
try
    problemsDir = fileparts(which('registry'));
    if ~isempty(problemsDir)
        refDir = fullfile(problemsDir, 'ref');
        if ~exist(refDir, 'dir'), mkdir(refDir); end
    end
catch
    % if registry not on path, skip caching
end

% Cache key
pid = problem.problemId;
n = numel(problem.x0);
key = sprintf('ref_pid%d_n%d_dir%s_ls%s_starts%d.mat', pid, n, lower(opts.direction), lower(opts.linesearch), starts);
cachePath = '';
if ~isempty(refDir)
    cachePath = fullfile(refDir, key);
end

% Load from cache if enabled and available
if useCache && ~isempty(cachePath) && exist(cachePath, 'file')
    S = load(cachePath, 'Pref');
    if isfield(S, 'Pref')
        Pref = S.Pref; return
    end
end

% Build reference via provided starts and/or multi-start
Pcols = [];

% Use provided start points if available
if isfield(opts,'x0_list') && ~isempty(opts.x0_list)
    X0 = opts.x0_list;
    if size(X0,1) ~= n
        error('build_reference_front:BadX0', 'x0_list must be n x k');
    end
    k = size(X0,2);
    for s = 1:k
        prob = problem; prob.x0 = X0(:,s);
        try
            [~, F, ~] = vop_solve(prob, opts); %#ok<ASGLU>
            Pcols = [Pcols, F]; %#ok<AGROW>
        catch
            % skip failures
        end
    end
    extra = max(0, starts - k);
else
    extra = starts;
end

% Add extra random starts if requested
if extra > 0
    seed = 1; if isfield(opts,'seed') && ~isempty(opts.seed), seed = opts.seed; end
    rng(seed);
    for s = 1:extra
        x0 = -1 + 2*rand(n,1);
        prob = problem; prob.x0 = x0;
        try
            [~, F, ~] = vop_solve(prob, opts); %#ok<ASGLU>
            Pcols = [Pcols, F]; %#ok<AGROW>
        catch
            % skip failures
        end
    end
end

if isempty(Pcols)
    Pref = []; return;
end

Pref = unique(Pcols', 'rows');
Pref = nondominated_rows(Pref);

% Save to cache if enabled
if useCache && ~isempty(cachePath)
    try, save(cachePath, 'Pref'); catch, end
end

end
