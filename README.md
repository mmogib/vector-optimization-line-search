# VOP Line-Search — MATLAB Implementation

This repository provides a unified MATLAB implementation of a line-search algorithm for Vector Optimization Problems (VOP). It consolidates legacy scripts into reusable directions, line-search strategies, and metrics with a clean layout.

## Structure
- `src/core/` — Solver and shared utilities (`vop_solve.m`, `hz_subproblem.m`).
- `src/directions/` — Search directions (`direction_hz.m`, `direction_prp.m`, `direction_sd.m`).
- `src/linesearch/` — Line-search wrappers (Wolfe, qWolfe, Zoom variants).
- `src/metrics/` — Metrics (hypervolume, purity, Gamma/Delta, Performance).
- `problems/` — Problem wrappers (`f1/f2/f3.m`, `g1/g2/g3.m`).
- `problems/data/` — All datasets (`.mat`) consolidated here.
- `problems/registry.m` — Problem IDs, names, and default dimensions.
- `experiments/` — Example runner scripts (e.g., `run_vop_demo.m`).
  - `run_vop_demo.m` — single-config demo with metrics.
  - `run_vop_sweep.m` — parameter sweep over directions/line-searches with metrics.

## Quick Start
1) Add paths (from anywhere):
- `run('<path-to-repo>/setup.m')` or in-repo `setup`
- Persist: `setup persist`
2) Solve a 2-objective problem (recommended defaults sd + qwolfe):
- `p = registry(); p = p(1);`
- `problem = struct('x0',randn(p.n,1),'problemId',p.id,'m',p.m);`
- `opts = struct('maxIter',200,'tol',1e-8);  % direction/linesearch default to sd+qwolfe`
- `[x, F, info] = vop_solve(problem, opts);`
3) Run the demo experiment:
- `run('experiments/run_vop_demo.m')` (prints hypervolume, purity, gamma-delta)
4) Run the sweep (optional):
- `run('experiments/run_vop_sweep.m')`

## Recommended Defaults
- A sweep across directions {hz, sd, prp} and line-searches {dwolfe1, dwolfe2, qwolfe} shows `sd + qwolfe` performs robustly across problems.
- HZ with qwolfe can be strong on some problems (requires Optimization Toolbox).
- Demo toggles baseline vs recommended via `useRecommended` at the top of `experiments/run_vop_demo.m`.

### Sample Demo Summary (sd + qwolfe)
```
pid=1 (P1): hv=0.4869, purity=1.0000, gamma-delta=14.26, avg-iters=1.00, runs=5
pid=2 (P2): hv=0.2334, purity=1.0000, gamma-delta=8.406, avg-iters=1.20, runs=5
pid=5 (P5): hv=0.5111, purity=1.0000, gamma-delta=0.6179, avg-iters=5.80, runs=5
pid=6 (P6): hv=0.2708, purity=1.0000, gamma-delta=0.03246, avg-iters=2.80, runs=5
pid=10 (P10): hv=0.3954, purity=1.0000, gamma-delta=4.916, avg-iters=4.80, runs=5
```

## Notes
- Evaluation uses the unified dispatcher via problem names (preferred) or legacy `problemId`:
  - `Ffun(x)` returns an m×1 vector; `Gfun(x)` returns a 1×m cell of gradients.
  - Legacy `f1/f2/f3` and `g1/g2/g3` have been removed. Use named problems (e.g., `IKK1`, `TE8`, `MOP5`) via `problem.name`.
- HZ uses a quadratic subproblem for direction and an adaptive update integrated into the direction function.
- Legacy `vector_optimization/*` scripts are deprecated and not used.
- HZ requires Optimization Toolbox (`quadprog`).

## Contributing
See `AGENTS.md` for guidelines, coding style, and the migration plan checklist.
