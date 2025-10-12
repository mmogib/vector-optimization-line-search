# Repository Guidelines

## Project Structure & Module Organization
- New source lives under `src/`:
  - `src/core/` (shared utilities; e.g., `hz_subproblem.m`)
  - `src/directions/` (e.g., `direction_hz.m`, `direction_hzn.m`, `direction_prp.m`, `direction_sd.m`)
  - `src/linesearch/` (e.g., `linesearch_wolfe_d1.m`, `linesearch_qwolfe.m`)
  - `src/metrics/` (moved from `vector_optimization/metrics/`)
- Legacy scripts under `vector_optimization/` are deprecated and not used.
- Problems consolidated under `problems/`:
  - `problems/` contains problem wrappers (`f1/f2/f3.m`, `g1/g2/g3.m`).
  - `problems/data/` contains all datasets (`.mat`). Ensure this folder is on the MATLAB path.
  - `problems/registry.m` lists available problem IDs, names, and default dimensions.

## Build, Test, and Development Commands
 - Setup from anywhere: `run('<repo>/setup.m')` or in-repo `setup`. Persist with `setup persist`.
- Lint example: `matlab -batch "checkcode('src/metrics/hypervolume.m')"`.
- Run tests (if present): `matlab -batch "runtests"` or in-session `runtests('tests')`.
 - Demo experiment (m=2, HZ + Wolfe): `run('experiments/run_vop_demo.m')` (prints hv, purity, gamma-delta).
 - Sweep experiment: `run('experiments/run_vop_sweep.m')` (compares directions/line-searches).

## Coding Style & Naming Conventions
- One public function per `.m` file. File name must match the function name.
- Indentation: 2 spaces; avoid tabs. Keep lines ≤ 100 chars.
- Names: lowercase, descriptive; avoid spaces. Prefer `myFunction` or `my_function` consistently within a folder; match existing local patterns.
- Add a help header: first comment line summarizes purpose; include brief I/O docs and examples.
- Keep scripts side-effect free when possible; separate I/O from computation.

## Testing Guidelines
- Use `matlab.unittest` with files named `Test*.m` under `tests/`, mirroring source folders (e.g., `tests/metrics/TestHypervolume.m`).
- Cover core line-search routines and metric calculations. Seed randomness (`rng(0)`) for reproducibility.
- Run locally with `runtests` and ensure failures provide clear diagnostics.

## Commit & Pull Request Guidelines
- Commits: imperative mood and scoped prefix when helpful (e.g., `[metrics] Add hypervolume bounds check`). Keep messages concise with a one-line summary and optional details.
- PRs must include: purpose and rationale, affected folders, run instructions (exact MATLAB commands), and sample outputs/plots or metric diffs. Link related issues.
- Avoid committing large `.mat` files; use Git LFS if new data is essential. Never modify original benchmark `.mat` files.

## Security & Configuration Tips
- Do not embed credentials or absolute local paths. Use relative paths and `addpath`.
- Prefer `startup.m` (git-ignored) for local configuration such as path additions.
- Ensure scripts can run non-interactively (compatible with `-batch`).

## Usage Example
Run a 2-objective solve with recommended defaults (sd + qwolfe):

```matlab
setup  % or run('<repo>/setup.m')
reg = registry(); p = reg(1);
problem = struct('x0', randn(p.n,1), 'problemId', p.id, 'm', p.m);
opts = struct('maxIter',200, 'tol',1e-8); % defaults to sd + qwolfe
[x, F, info] = vop_solve(problem, opts);
disp(F); disp(info.reason);
```

## Recommended Defaults
- Direction: `sd`; Line-search: `qwolfe` for m=2.
- Alternative: `hz` + `qwolfe` (requires Optimization Toolbox) can perform well on some problems.

## Phase 0: Inventory Summary
- One solver concept with multiple search directions (HZ, HZN, PRP/PRP1, SD) and line-search strategies (Wolfe, quadratic Wolfe, Zoom variants). Code is split by objective count, causing duplication.
- Metrics functions centralized under `vector_optimization/metrics/`: `dominates.m`, `Gamma_Delta.m`, `hypervolume.m`, `Performance.m`, `purity.m`.
- Line-search functions duplicated across folders: `dwolfe*.m`, `qwolfe*.m`, and `zoom*.m` appear in 2/3/>3 objective folders with near-identical logic.
- Direction implementations are scripts (not functions) duplicated per folder: `HZ.m`, `HZN.m`, `PRP1.m`, `SD.m`, mixing experiment setup with algorithm internals.
- Problem wrappers split per objective-count: `f1/f2/f3.m`, `g1/g2/g3.m`; they select datasets via a `d` switch and couple evaluation with data loading.
- Datasets (`.mat`) are colocated with scripts; names repeat across folders (e.g., `JOS1.mat` sizes vary). No clear central problems registry.
- No unified entry point (e.g., `vop_solve`) detected; experiments start from per-folder scripts.

Duplicates to consolidate (representative)
- Directions/scripts: `HZ.m`, `HZN.m`, `PRP1.m`, `SD.m`.
- Line-search: `dwolfe1/2/3/41/42/43.m`, `qwolfe/2/3/4.m`, `zoom11/12/21/22/*`.
- Problems: `f1.m`, `f2.m`, `g1.m`, `g2.m` across 2/3 objective folders.

Immediate path forward
- Keep existing folders intact. Create target skeleton: `src/core`, `src/directions`, `src/linesearch`, `problems`, `experiments`, `tests`.
- Next, extract directions and line-search into function APIs under `src/*` and leave thin experiment scripts under `experiments/`.

## Plan
Refactor Plan for VOP Line-Search Repository

Checklist (authoritative)

- [x] Phase 0 — Inventory & Mapping
  - [x] Catalogue `.m` files by role (core, directions, line-search, problems, metrics, utilities).
  - [x] Identify duplicates/overlaps and choose canonical sources.

- [x] Phase 1 — Target Structure
  - [x] Create folders: `src/core/`, `src/directions/`, `src/linesearch/`, `problems/`, `src/metrics/`, `experiments/`, `tests/`.
  - [x] Define relocation rules for scripts and `.mat` datasets.

- [x] Phase 2 — API Unification
  - [x] Directions: `direction_sd`, `direction_prp`, `direction_hz/hzn` (initial v via QP, adaptive update in solver).
  - [x] Line search wrappers: `linesearch_*` covering Wolfe/qWolfe/Zoom for m=2 and m=3.
  - [x] Solver: `vop_solve(problem, opts)` implemented with unified loop and HZ/HZN betaki update.
  - [x] Metrics relocated to `src/metrics/`.

- [ ] Phase 3 — Migration & Cleanup
  - [ ] Remove legacy duplicates under `vector_optimization/*` (keep `.mat` datasets).
  - [ ] Consolidate problems under `problems/` (functions + data folders).
  - [ ] Optional: add problem registry (IDs → metadata) for clarity.

- [ ] Phase 4 — Validation
  - [ ] Run experiments and compare key metrics (hypervolume, purity, Gamma/Delta).
  - [ ] Document any intentional changes.

- [ ] Phase 5 — Docs & Examples
  - [ ] Expand examples and usage notes in AGENTS.md.

- Phase 0 — Inventory & Mapping
  - Catalogue all `.m` files by role: core solver, search directions (PRP, SD, HZ/HZN, etc.), line-search strategies (Armijo/Wolfe/Zoom), problems/datasets, scripts, metrics, utilities. Note duplicates and overlaps.

- Phase 1 — Target Structure
  - `src/core/` (main solver, shared utils)
  - `src/directions/` (PRP, SD, HZ, HZN, ...)
  - `src/linesearch/` (armijo, wolfe, zoom, backtracking)
  - `problems/` (problem functions and `.mat` datasets)
  - `metrics/` (existing metrics moved if needed)
  - `experiments/` (runner scripts, configs)
  - `tests/` (matlab.unittest)

- Phase 2 — API Unification (no behavior change)
  - Directions: `d = direction_<name>(x, grad, history, opts)`
  - Line search: `[alpha, info] = linesearch_<name>(f, g, x, d, opts)`
  - Core solver: `[x, F, info] = vop_solve(problem, opts)`
  - Standardize `opts`, seeding, and shared stop criteria.

- Phase 3 — Non-destructive Migration
  - Move files into target folders; remove spaces in filenames; add compatibility shims that forward to the unified API. Extract common code to `src/core/`. Remove true duplicates after parity checks.

- Phase 4 — Validation & Parity
  - Run golden benchmarks and compare metrics (hypervolume, purity, Gamma/Delta). Investigate any regressions; document intentional differences.

- Phase 5 — Cleanup & Docs
  - Remove shims after callers are updated. Refresh AGENTS.md and usage examples.

Open Questions (to confirm before executing)
- MATLAB version support and whether Octave is required.
- Whether `.mat` datasets can be relocated under `problems/`.
- Public entry scripts that must keep current names.
- Priority combinations to validate first (e.g., PRP + Wolfe).
- Preferred naming style for new files: `camelCase` vs `snake_case`.
