# Kickoff Prompt: Next Session

Context
- Directions unified (HZ/PRP+/SD); HZN removed. HZ update hardened. PRP+ supports beta capping and optional restart.
- Line-searches consolidated (DWOLFE/QWOLFE wrappers); zoom/duplicates removed.
- Solver: unified `vop_solve` with `recordIntermediateEvery`; tuned defaults (m=2: sd + qwolfe). HZ defaults documented (mu=1, c=0.2, ita=1e-2).
- Performance profiles pipeline is live:
  - Save runs to CSV: `experiments/run_save_results.m` (versioned `results_vN.csv` + `results_latest.csv`).
  - Load + plot: `src/metrics/load_performance_from_csv.m` + `experiments/plot_profiles_from_csv.m`.
  - Inline profiles (fresh runs): `experiments/run_performance_profiles.m`.
- Problems: centralized under `problems/` with `problems/registry.m` and `problem_glossary()` helper.
- Outputs policy: `outputs/` artifacts are git-ignored; `.gitkeep` only. Console progress integrated in long experiments.
- Docs Phase 1 completed: README overhauled; new guides under `docs/` (experiments, profiles_from_csv, solver_options, problems, testing).

Goals for next session
1) Add VSD metric end-to-end
   - Track `info.vsd` (Vector Steepest-Descent evaluations) in `vop_solve`/directions where applicable; add `vsd` to CSV; extend loader/plotter to include `data.vsd`.

2) Solver/runtime polish
   - Add `opts.verbosity` (0: quiet, 1: brief, 2: detailed) and standardize prints across experiments.
   - Ensure qWolfe/HZ params are captured in CSV metadata when set (e.g., Wolfe constants, HZ mu/c/ita).

3) Tests (matlab.unittest)
   - Unit tests for CSV loader and plotting: NaN/failure handling, stable label ordering.
   - Smoke tests: HZ/PRP/SD × DWOLFE/QWOLFE on a tiny subset.

4) Docs Phase 2
   - Add `docs/generate_docs.m` to publish lightweight API HTML from help headers into `docs/api/` and seed an index page.

5) Cleanup
   - Audit and remove any remaining legacy duplicates if present; ensure `problems/data/` stays on path via `setup`.

Suggested Next Steps
- Implement `info.vsd` and wire to CSV/loader/plotter.
- Add `opts.verbosity` and CSV enrichment for qWolfe/HZ params.
- Add unit tests (CSV/plots) and minimal smoke tests.
- Add `docs/generate_docs.m` and stub API index.

Notes
- Keep one public function per file, 2-space indentation, ≤100-char lines, avoid tabs.
- Scripts must run non-interactively (compatible with `-batch`).

Persistent TODO (keep until completed)
- Add VSD metric end-to-end (solver → CSV → loader/plots).

