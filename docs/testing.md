# Testing

The repository uses `matlab.unittest` for unit and smoke tests (when present).

## Running Tests
- From MATLAB: `runtests` or `runtests('tests')`
- From CLI: `matlab -batch "runtests"`

## Guidelines
- Place tests under `tests/` with files named `Test*.m`.
- Mirror source layout where practical (e.g., `tests/metrics/TestHypervolume.m`).
- Seed randomness for reproducibility: `rng(0)`.
- Ensure failures include clear diagnostics.

## Coverage Suggestions
- Metrics: hypervolume, purity, non-dominated filtering.
- CSV pipeline: loader handles NaN/failure rows; plotting label ordering stable.
- Smoke: SD/PRP/HZ with DWOLFE/QWOLFE run without errors on a tiny subset.

