function Pref = build_reference_front(problem, opts, starts)
% build_reference_front  Minimal reference front via multi-start solve + nondomination.
%   Pref: rows (points) x objectives (M)

if nargin < 3 || isempty(starts), starts = 5; end
if nargin < 2 || isempty(opts), opts = struct(); end

% Recommended defaults if not set
if ~isfield(opts,'direction'), opts.direction = 'sd'; end
if ~isfield(opts,'linesearch'), opts.linesearch = 'qwolfe'; end
if ~isfield(opts,'maxIter'), opts.maxIter = 200; end
if ~isfield(opts,'tol'), opts.tol = 1e-8; end

Pcols = [];
rng(1);
for s = 1:starts
    x0 = -1 + 2*rand(numel(problem.x0),1);
    prob = problem; prob.x0 = x0;
    try
        [~, F, ~] = vop_solve(prob, opts); %#ok<ASGLU>
        Pcols = [Pcols, F]; %#ok<AGROW>
    catch
        % skip failures
    end
end

if isempty(Pcols)
    Pref = []; return;
end

Pref = unique(Pcols', 'rows');
Pref = nondominated_rows(Pref);

end

