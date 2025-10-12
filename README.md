# VOP Line-Search — MATLAB Implementation

This repository provides a unified MATLAB implementation of a line-search algorithm for Vector Optimization Problems (VOP). It consolidates legacy scripts into reusable directions, line-search strategies, and metrics with a clean layout.

## Structure
- `src/core/` — Solver and shared utilities (`vop_solve.m`, `hz_subproblem.m`).
- `src/directions/` — Search directions (`direction_hz.m`, `direction_hzn.m`, `direction_prp.m`, `direction_sd.m`).
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
2) Solve a 2-objective problem with HZ + Wolfe:
- `p = registry(); p = p(1);`
- `problem = struct('x0',randn(p.n,1),'problemId',p.id,'m',p.m);`
- `opts = struct('direction','hz','linesearch','dwolfe1','maxIter',200,'tol',1e-8);`
- `[x, F, info] = vop_solve(problem, opts);`
3) Run the demo experiment:
- `run('experiments/run_vop_demo.m')` (prints hypervolume, purity, gamma-delta)
4) Run the sweep (optional):
- `run('experiments/run_vop_sweep.m')`

## Notes
- The solver uses `f1/f2/f3` and `g1/g2/g3` to evaluate objectives/gradients by `problemId`; ensure `problems/data` is on the path (setup handles this).
- HZ/HZN use a quadratic subproblem for direction and an adaptive update inside the solver.
- Legacy `vector_optimization/*` scripts are deprecated and not used.
- HZ/HZN require Optimization Toolbox (`quadprog`).

## Contributing
See `AGENTS.md` for guidelines, coding style, and the migration plan checklist.
