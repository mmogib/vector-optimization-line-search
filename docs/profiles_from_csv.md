# Profiles From CSV

This guide shows how to produce performance profiles from saved CSV results.

## Save Results
- Optionally restrict the problems set:
  - `problems = {'IKK1','TE8','MOP5'};`
- Run the saver:
  - `run('experiments/run_save_results.m')`
- Outputs:
  - `outputs/runs/results_vN.csv` (versioned) and `outputs/runs/results_latest.csv` (symlink/update).

## Plot Profiles From CSV
- Use the plotting script to load the latest CSV and generate figures:
  - `run('experiments/plot_profiles_from_csv.m')`
- Figures are written to `outputs/performance/`.

## CSV Schema (selected fields)
- Identifiers: `problem`, `n`, `m`.
- Settings: `direction`, `linesearch`, plus any set line-search params (Wolfe/qWolfe, HZ where applicable).
- Results: `success`, `reason`, `iterations`, `fev` (function evals), `gev` (gradient evals), `cpu_time_sec`.

Notes
- All scripts are batch-friendly and print progress.
- Artifacts under `outputs/` are git-ignored by design.

