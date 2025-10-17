# VOP Line-Search — MATLAB Implementation

Unified MATLAB solver for line-search methods in Vector Optimization Problems (VOP). The codebase exposes pluggable search directions (SD, PRP+, HZ) and line-search strategies (Wolfe, quadratic Wolfe), plus utilities for metrics and performance profiles.

## Algorithm Overview
- Core loop: at iterate `x_k`, compute a descent direction `d_k` via a chosen direction rule, then perform a scalar line search to select step length `alpha_k` that satisfies Wolfe or quadratic Wolfe conditions for the multiobjective setting. Update `x_{k+1} = x_k + alpha_k d_k`.
- Directions:
  - `sd`: steepest descent of a weighted sum of gradients with adaptive scaling.
  - `prp`: Polak–Ribière–Polyak variant with safeguards (beta capping / optional restart).
  - `hz`: Hager–Zhang style direction using a small quadratic subproblem (m=2) with robust parameter updates.
- Line-searches: unified wrappers for strong Wolfe (`dwolfe*`) and quadratic Wolfe (`qwolfe*`) with consistent inputs/outputs and safe option handling.

## Repository Layout
- `src/core/` — solver and shared utilities (`vop_solve.m`, `hz_subproblem.m`, `problem_dispatcher.m`, `problem_glossary.m`).
- `src/directions/` — `direction_hz.m`, `direction_prp.m`, `direction_sd.m`.
- `src/linesearch/` — `linesearch_wolfe_d*.m`, `linesearch_qwolfe*.m`, `linesearch_dwolfe.m`.
- `src/metrics/` — metrics and plotting utilities (hypervolume, purity, Gamma/Delta, performance profiles, CSV loader).
- `problems/` — named problem wrappers and datasets in `problems/data/`; `problems/registry.m` lists available problems.
- `experiments/` — ready-to-run scripts for demos, sweeps, profiles, and line-search comparisons.
- `outputs/` — artifacts are git-ignored; only `.gitkeep` is tracked.

## Setup
- In MATLAB: `run('<repo>/setup.m')` or from repo root: `setup`
- Persist paths across sessions: `setup persist`

## List Available Problems
- Quick glossary (with optional filter):
  - `problem_glossary()`
  - `problem_glossary({'IKK1','TE8'})`
- Programmatic registry:
  - `reg = registry();`  % array of structs: `name, n, m`

## Solve One Problem (with options)
```
setup
reg = registry(); p = reg(1);               % pick a problem
problem = struct('x0', randn(p.n,1), ...
                 'name', p.name, ...        % preferred over numeric IDs
                 'm', p.m);
opts = struct('direction','sd', ...          % 'sd' | 'prp' | 'hz'
              'linesearch','qwolfe', ...     % m=2: 'dwolfe1' | 'dwolfe2' | 'qwolfe'
              'maxIter',200, ...
              'tol',1e-8, ...
              'recordIntermediateEvery',0, ...
              'verbose',0);
[x, F, info] = vop_solve(problem, opts);
disp(F); disp(info.reason);
```
Notes
- Defaults (m=2): `direction='sd'`, `linesearch='qwolfe'`.
- HZ requires Optimization Toolbox for the subproblem.

## Run Experiments on Multiple Problems
- Inline performance profiles from fresh runs:
  - `run('experiments/run_performance_profiles.m')`
- Save results to CSV (versioned) then plot profiles:
  - Optionally set a subset: `problems = {'IKK1','TE8','MOP5'};`
  - `run('experiments/run_save_results.m')`  % writes `outputs/runs/results_vN.csv`
  - `run('experiments/plot_profiles_from_csv.m')`  % saves figures to `outputs/performance/`
- Compare line-searches with a fixed direction over random starts:
  - `run('experiments/run_linesearch_compare.m')`  % writes CSV + performance plot

## Extend: Add a New Problem
1) Create two functions in `problems/`:
   - `myprob_f.m`: returns `F(x)` as an `m×1` vector
   - `myprob_g.m`: returns a `1×m` cell array of gradients `{g1(x),...,gm(x)}`
   - Include a brief help header, domain notes, and reference.
2) Register it in `problems/registry.m` with fields `name, n, m`.
3) Map the name in `src/core/problem_dispatcher.m` if not auto-resolved by naming.

## Extend: Add a New Line-Search
1) Implement `src/linesearch/linesearch_<name>.m` with signature:
   - `[alpha, info] = linesearch_<name>(~, ~, x, d, opts)`
   - `info` may include `iters, nf, ng, reason`.
2) Accept `opts` fields used elsewhere (`alphamax`, Wolfe constants, problem inputs via dispatcher).
3) Wire it in `src/core/vop_solve.m` switch on `opts.linesearch`.
4) Add a smoke test in `tests/` (optional; see docs/testing.md).

## Extend: Add a New Direction
1) Implement `src/directions/direction_<name>.m` with signature:
   - `[d, state] = direction_<name>(x, gsum, history, opts)`
   - For multiobjective methods that need `F/G` directly (e.g., HZ), pass via `opts` and follow the `direction_hz` pattern.
2) Return `state` fields as needed (`iters, nf, ng, history`).
3) Wire it in `src/core/vop_solve.m` switch on `opts.direction`.

## Outputs and Logs
- Results CSV and images are written under `outputs/` (git-ignored).
- Long experiments print a single-line progress with percent, count, elapsed, ETA.

## More Documentation
- See `docs/` for focused guides:
  - `docs/profiles_from_csv.md` — CSV → profiles walkthrough
  - `docs/experiments.md` — demos, sweeps, line-search compare
  - `docs/solver_options.md` — solver options and defaults
  - `docs/problems.md` — registry/glossary and adding problems

## Contributing
See `AGENTS.md` for coding style and the migration plan. Tests (if present) run with `runtests`.

Note
- Future work: add the VSD metric end-to-end (solver → CSV → loader/plots).

