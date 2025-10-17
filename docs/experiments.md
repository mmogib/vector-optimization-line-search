# Experiments

This folder contains ready-to-run scripts for demos, sweeps, and performance profile generation. All outputs are written under `outputs/` (CSV under `outputs/runs/`, figures under `outputs/performance/`) and are git-ignored.

## Inline Performance Profiles
- Run fresh experiments and directly plot performance profiles without saving CSV:
  - `run('experiments/run_performance_profiles.m')`

## Save Results to CSV, Then Plot
- Optionally select a subset of problems before running:
  - `problems = {'IKK1','TE8','MOP5'};`
- Save results (writes `outputs/runs/results_vN.csv` and `outputs/runs/results_latest.csv`):
  - `run('experiments/run_save_results.m')`
- Plot performance profiles from CSV (saves figures to `outputs/performance/`):
  - `run('experiments/plot_profiles_from_csv.m')`

## Compare Line-Searches
- Compare line-search strategies with a fixed direction over random starts drawn from problem domains:
  - `run('experiments/run_linesearch_compare.m')`
- Captures: `iterations`, `fev`, `gev`, and `cpu_time_sec`, plus `success` and `reason`.

## Direction Sanity Check
- Quick sweep to ensure directions produce reasonable steps on a small set:
  - `run('experiments/run_direction_sanity.m')`

## HZ Tuning
- Grid or random sweep over HZ parameters with in-place summaries:
  - `run('experiments/run_hz_tuning.m')`
  - `run('experiments/summarize_hz_tuning.m')`

## Console Progress
- Long-running experiments print one-line progress with percentage, count, elapsed, and ETA. Scripts are non-interactive (batch-friendly).

