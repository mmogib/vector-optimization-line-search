# Solver Options

Options accepted by `src/core/vop_solve.m`.

## Core
- `direction` (char)
  - m=2 default: `sd`. Choices: `sd` | `prp` | `hz` (HZ supports m=2).
- `linesearch` (char)
  - m=2 default: `qwolfe`. Choices: `dwolfe1` | `dwolfe2` | `qwolfe` | `dwolfe` (unified strong Wolfe).
  - m=3 default: `dwolfe3`. Choices include `dwolfe3`, `dwolfe41`, `dwolfe42`, `dwolfe43`, `qwolfe3`, `qwolfe4`.
- `maxIter` (int) — default `500`.
- `tol` (double) — step-norm tolerance; default `1e-8`.
- `alphamax` (double) — max step; default `1e10`.
- `verbose` (0/1) — per-iteration prints; default `0`.
- `gradTol` (double) — weighted-sum gradient infinity-norm stop; default `1e-6`.
- `recordIntermediateEvery` (int) — collect objective vectors every K iterations (stores in `info.intermediateF`); default `0` (off).

## Pass-through Line-Search Params
- Wolfe constants (if used by your implementation):
  - `rhoba`, `sigmaba`
- Unified strong Wolfe (`linesearch_dwolfe`):
  - `anchor` (initial step heuristic selector)
- Some 3-objective wrappers:
  - `epsiki`

## Problem Specification
- Prefer `problem.name` (e.g., `BK1`, `TE8`, `MOP5`); set `problem.m` and `problem.x0`.
- Optional scaling `problem.r` (row vector of length `m`). If absent, the solver computes `r_i = 1 / max(1, ||g_i||_inf)` at the current point.

## Outputs (`info` struct)
- `iters`, `alphas`, `nf`, `ng`, `ls_internal_iters`, `dir_internal_iters`, `reason`, `direction`, `linesearch`.
- When recording history: `info.X`, `info.Fhist`; when collecting intermediates: `info.intermediateF`.

Notes
- HZ requires Optimization Toolbox for the subproblem in `direction_hz`.

