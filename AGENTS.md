# Repository Guidelines

## Session Summary (Oct 2025)
- Directions unified and hardened:
  - Removed HZN; `direction_hzn` deleted, solver accepts `hz|sd|prp` only.
  - HZ adaptive update made robust to environment (no reliance on shadowed builtins like `isempty`/`iscell`).
  - PRP+ niceties: beta capping and optional restart supported.
- Line-searches consolidated:
  - Unified DWOLFE and QWOLFE wrappers (`src/linesearch/*`), NaN/empty-safe options handling.
  - Zoom and duplicate legacy variants removed.
- Solver improvements:
  - `recordIntermediateEvery` option for collecting intermediate objective vectors.
  - Tuned sd + qwolfe defaults wired in demo/sweep; HZ defaults documented (mu=1, c=0.2, ita=1e-2).
- Metrics & profiling:
  - New plotting utilities: `plot_performance_profile.m` and `plot_performance_profiles.m`.
  - CSV pipeline: `run_save_results.m` (writes versioned CSVs), `load_performance_from_csv.m`, and `plot_profiles_from_csv.m`.
  - Removed legacy `Performance.m` and unused `dominates.m`.
- Experiments:
  - Added `run_performance_profiles.m` (inline) and `run_direction_sanity.m` (quick direction smoke test).
  - All experiments save artifacts under `outputs/performance/` and logs under `logs/`.
- Outputs policy:
  - `outputs/` folder is tracked with `.gitkeep` only; artifacts are git‑ignored.
  - New files written to `outputs/performance/` and `outputs/runs/` are not committed.

## Project Structure & Module Organization
- New source lives under `src/`:
  - `src/core/` (shared utilities; e.g., `hz_subproblem.m`)
  - `src/directions/` (e.g., `direction_hz.m`, `direction_prp.m`, `direction_sd.m`)
  - `src/linesearch/` (e.g., `linesearch_wolfe_d1.m`, `linesearch_qwolfe.m`)
  - `src/metrics/` (moved from `vector_optimization/metrics/`)
- Legacy scripts under `vector_optimization/` are deprecated and not used.
- Problems consolidated under `problems/`:
  - `problems/` contains problem wrappers (`f1/f2/f3.m`, `g1/g2/g3.m`).
  - `problems/data/` contains all datasets (`.mat`). Ensure this folder is on the MATLAB path.
 - `problems/registry.m` lists available problem IDs, names, and default dimensions.
 - Documentation lives under `docs/` (documentation only).
   - Planning/coordination must be kept in `AGENTS.md` and the next-session prompt in `NEXT_PROMPT.md`.
   - See `docs/legacy_migration_checklist.md` for the historical migration checklist.

## Build, Test, and Development Commands
 - Setup from anywhere: `run('<repo>/setup.m')` or in-repo `setup`. Persist with `setup persist`.
- Lint example: `matlab -batch "checkcode('src/metrics/hypervolume.m')"`.
- Run tests (if present): `matlab -batch "runtests"` or in-session `runtests('tests')`.
 - Demo experiment (m=2, HZ + Wolfe): `run('experiments/run_vop_demo.m')` (prints hv, purity, gamma-delta).
- Sweep experiment: `run('experiments/run_vop_sweep.m')` (compares directions/line-searches).
- Save CSV results (versioned): `run('experiments/run_save_results.m')` (writes `outputs/runs/results_vN.csv` and updates `results_latest.csv`).
- Plot profiles from CSV: `run('experiments/plot_profiles_from_csv.m')` (saves figures to `outputs/performance/`).
- Inline profiles (fresh runs, no CSV): `run('experiments/run_performance_profiles.m')`.
- Direction sanity sweep: `run('experiments/run_direction_sanity.m')`.

## Running For One Or Many Problems
- Most experiments accept a workspace variable `problems` (cell array of names) to filter the registry:
  - One problem:
    - `problems = {'IKK1'}; run('experiments/run_vop_demo.m')`
  - Multiple:
    - `problems = {'IKK1','TE8','MOP5'}; run('experiments/run_save_results.m')`
- Without `problems` set, scripts default to the P‑set subset: `{'IKK1','TE8','MOP5','MOP7','SLCDT2'}`.
- CSV → Profiles workflow:
  - Save results: `problems = {'IKK1','TE8'}; run('experiments/run_save_results.m')`
  - Plot from latest CSV: `run('experiments/plot_profiles_from_csv.m')`

## Problem Glossary
- Print a short glossary with reference keys: `problem_glossary()`
- Filter output: `problem_glossary({'IKK1','TE8'})`
- References correspond to keys in `refs/problems.tex` (see that file for full details and formulations).

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
- Console progress: long‑running experiments print a one‑line progress with percentage, count, elapsed, and ETA.

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
- One solver concept with multiple search directions (HZ, PRP/PRP1, SD) and line-search strategies (Wolfe, quadratic Wolfe, Zoom variants). Code is split by objective count, causing duplication.
- Metrics functions centralized under `vector_optimization/metrics/`: `dominates.m`, `Gamma_Delta.m`, `hypervolume.m`, `Performance.m`, `purity.m`.
- Line-search functions duplicated across folders: `dwolfe*.m`, `qwolfe*.m`, and `zoom*.m` appear in 2/3/>3 objective folders with near-identical logic.
- Direction implementations are scripts (not functions) duplicated per folder: `HZ.m`, `PRP1.m`, `SD.m`, mixing experiment setup with algorithm internals.
- Problem wrappers split per objective-count: `f1/f2/f3.m`, `g1/g2/g3.m`; they select datasets via a `d` switch and couple evaluation with data loading.
- Datasets (`.mat`) are colocated with scripts; names repeat across folders (e.g., `JOS1.mat` sizes vary). No clear central problems registry.
- No unified entry point (e.g., `vop_solve`) detected; experiments start from per-folder scripts.

Duplicates to consolidate (representative)
- Directions/scripts: `HZ.m`, `PRP1.m`, `SD.m`.
- Line-search: `dwolfe1/2/3/41/42/43.m`, `qwolfe/2/3/4.m`, `zoom11/12/21/22/*`.
- Problems: `f1.m`, `f2.m`, `g1.m`, `g2.m` across 2/3 objective folders.

Immediate path forward
- Keep existing folders intact. Create target skeleton: `src/core`, `src/directions`, `src/linesearch`, `problems`, `experiments`, `tests`.
- Next, extract directions and line-search into function APIs under `src/*` and leave thin experiment scripts under `experiments/`.

## Plan
Refactor Plan for VOP Line-Search Repository (live)

Checklist (authoritative)

- [x] Phase 0 — Inventory & Mapping
  - [x] Catalogue `.m` files by role (core, directions, line-search, problems, metrics, utilities).
  - [x] Identify duplicates/overlaps and choose canonical sources.

- [x] Phase 1 — Target Structure
  - [x] Create folders: `src/core/`, `src/directions/`, `src/linesearch/`, `problems/`, `src/metrics/`, `experiments/`, `tests/`.
  - [x] Define relocation rules for scripts and `.mat` datasets.

- [x] Phase 2 — API Unification
- [x] Directions: `direction_sd`, `direction_prp`, `direction_hz` (initial v via QP, adaptive update in direction).
  - [x] Line search wrappers: `linesearch_*` covering Wolfe/qWolfe/Zoom for m=2 and m=3.
- [x] Solver: `vop_solve(problem, opts)` implemented with unified loop and HZ betaki update.
  - [x] Metrics relocated to `src/metrics/`.

- [x] Phase 3 — Migration & Cleanup
  - [x] Introduce unified problem dispatcher (`problem_dispatcher.m`).
  - [x] Wire solver and HZ subproblem to dispatcher; refactor `qwolfe` to use it (m=2).
  - [x] Deduplicate TE8/FDS via family wrappers (`te8_f/g`, `fds_f/g`) and delegate from `f*/g*`.
  - [x] Convert remaining m=2 line-search internals (dwolfe*/zoom variants) to dispatcher or remove; unified DWOLFE/QWOLFE implemented.
  - [x] Remove legacy direct calls to `f1/f2/f3` and `g1/g2/g3` once all call sites use dispatcher (legacy files removed and fallback disabled).
  - [ ] Remove legacy duplicates under `vector_optimization/*` (keep `.mat` datasets).
  - [~] Consolidate problems under `problems/` (functions + data folders) with family wrappers (partially complete; more families can be added).
  - [~] Optional: expand problem registry (IDs → metadata, refs/domains) (partially complete).

- [x] Phase 4 — Validation
  - [x] Demo and sweep run with logging (`logs/*.txt` ignored). Purity robustness improved (relative tol, overlap).
  - [x] HZ tuning sweep added (`experiments/run_hz_tuning.m`) with logs and summarizer.
  - [x] Re-run after dispatcher/linesearch/directions consolidation; compared hv/purity/gamma-delta.
  - [ ] Document any intentional changes.

- [ ] Phase 5 — Docs & Examples
  - [ ] Expand examples and usage notes in AGENTS.md.
  - [x] Keep docs/ for documentation only; planning in AGENTS.md and NEXT_PROMPT.md (enforced).

## MIGRATION CHECK LIST
Scope: remove direct uses of `f1/f2/f3` and `g1/g2/g3` in favor of the unified dispatcher API: `Ffun(x)` (m×1), `Gfun(x)` (1×m cell).

Owner: refactoring branch

- [x] Add dispatcher `src/core/problem_dispatcher.m` (TE8, FDS families mapped; legacy fallback removed)
- [x] Wire solver `src/core/vop_solve.m` to use dispatcher (eval/scale path)
- [x] Wire `src/core/hz_subproblem.m` to use dispatcher for g1/g2
- [x] Refactor line-searches to use dispatcher/unified engines (DWOLFE/QWOLFE unified)
- [x] Deduplicate TE8/FDS families (`problems/te8_f/g.m`, `problems/fds_f/g.m`); delegate from legacy wrappers (legacy files now removed)

Next (m=2 line-search internals)
- [x] Convert/remove legacy `dwolfe1_2obj.m` to use dispatcher (replaced by unified DWOLFE)
- [x] Convert/remove legacy `dwolfe2_2obj.m`
- [x] Convert/remove `zoom11_2obj.m` and `zoom12_2obj.m`
- [x] Convert/remove `zoom21_2obj.m` and `zoom22_2obj.m`
- [x] Validate `qwolfe` end-to-end on demo/sweep after consolidation

Problem families & registry
- [x] Add `problems/vu1_f.m` and `problems/vu1_g.m` (VU2001), include domain notes; map in dispatcher
- [x] Add `problems/sp1_f.m` and `problems/sp1_g.m` (SP1997), include domain notes; map in dispatcher
- [x] Migrate MOP5/MOP7 to named wrappers and map in dispatcher
- [~] Extend `problems/registry.m` with selected datasets and notes from `refs/problems.tex` (partially complete)

Validation & cleanup
- [x] Re-run `experiments/run_vop_demo.m` and `experiments/run_vop_sweep.m`; compare hv/purity/gamma-delta to prior logs
- [ ] Remove legacy duplicates under `vector_optimization/*` (keep `.mat` datasets)
- [x] Decide disposition of `f1/f2/f3` and `g1/g2/g3` (removed; deprecate in README if referenced)

Notes
- Keep `G` as a 1×m cell array; `F` as m×1.
- Prefer shared helper for directional derivative evaluation in linesearch code to avoid duplication.

- Phase 0 — Inventory & Mapping
  - Catalogue all `.m` files by role: core solver, search directions (PRP, SD, HZ, etc.), line-search strategies (Armijo/Wolfe/Zoom), problems/datasets, scripts, metrics, utilities. Note duplicates and overlaps.

- Phase 1 — Target Structure
  - `src/core/` (main solver, shared utils)
  - `src/directions/` (PRP, SD, HZ, ...)
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

Notes this session
- Metrics: `purity.m` now tolerance-based (abs+relative), `compute_metrics` calls purity with rtol=5e-2.
- Reference fronts: caching enabled in `build_reference_front` with `problems/ref/` and seeded overlap for demo.
- Logs: use `logs/` (tracked via `.gitkeep`); all `*.log` and `logs/*.txt` are git-ignored.
- Dispatcher introduced and partially adopted (solver, HZ subproblem, `qwolfe`).
- Performance profiles: CSV pipeline added (`run_save_results.m`, `load_performance_from_csv.m`, `plot_profiles_from_csv.m`); plotting utilities added under `src/metrics/`.
- Outputs policy: `outputs/` artifacts are ignored; `.gitkeep` preserves folder structure.

Open Questions (to confirm before executing)
- MATLAB version support and whether Octave is required.
- Whether `.mat` datasets can be relocated under `problems/`.
- Public entry scripts that must keep current names.
- Priority combinations to validate first (e.g., PRP + Wolfe).
- Preferred naming style for new files: `camelCase` vs `snake_case`.
