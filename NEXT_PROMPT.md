# Kickoff Prompt: Next Session

Context
- Directions unified (HZ/PRP+/SD); HZN removed. HZ update hardened. PRP+ supports beta capping and optional restart.
- Line-searches consolidated (DWOLFE/QWOLFE wrappers); zoom/duplicates removed.
- Solver supports `recordIntermediateEvery`; demos use tuned sd+qwolfe; HZ defaults documented (mu=1, c=0.2, ita=1e-2).
- Performance profiles pipeline is live:
  - Save runs → CSV: `experiments/run_save_results.m` (versioned `results_vN.csv` + `results_latest.csv`).
  - Load + plot: `src/metrics/load_performance_from_csv.m` + `experiments/plot_profiles_from_csv.m`.
  - Inline profiles (fresh runs): `experiments/run_performance_profiles.m`.
- Outputs policy: `outputs/` artifacts are git-ignored; `.gitkeep` only.
- Console progress integrated in long experiments (headless friendly).

Goals for next session
1) Add VSD metric end-to-end
   - Track `info.vsd` (vector steepest-descent evaluations) in `vop_solve`/line-search when applicable; add `vsd` to CSV; extend loader/plotter to include `data.vsd`.

2) Tests (matlab.unittest)
   - Unit tests for plotting utilities and CSV loader with small fixtures (NaN/failure handling, label ordering).
   - Smoke tests ensuring HZ/PRP/SD with DWOLFE/QWOLFE run without errors on a tiny subset.

3) Solver/runtime polish
   - Add `verbosity` option to `vop_solve` (0/1/2) and standardize experiment prints.
   - Ensure qWolfe/HZ params are always recorded in CSV when set.

4) Docs
   - Expand README with a concise “Profiles From CSV” walkthrough and example commands.

Suggested Next Steps
- Implement `info.vsd` and wire to CSV/loader/plotter.
- Add unit tests for metrics/profiles and direction/linesearch combos.
- Update README with the CSV → profiles workflow.

Notes
- Keep one public function per file, ≤100-char lines, and avoid tabs.
