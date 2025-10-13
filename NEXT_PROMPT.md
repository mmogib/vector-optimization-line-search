# Kickoff Prompt: Next Session

Context
- Unified problem API introduced via `src/core/problem_dispatcher.m`.
- Solver (`vop_solve`) and `hz_subproblem` now evaluate F/G through dispatcher; `qwolfe` refactored to use it (m=2).
- TE8 and FDS are consolidated as family wrappers (`problems/te8_f/g.m`, `problems/fds_f/g.m`).
- Legacy `f1/f2/f3` and `g1/g2/g3` delegate TE8/FDS to the new wrappers.
- Metrics robustness improved: `purity` uses abs+relative tolerance; reference fronts cache in `problems/ref/`.
- Logs are under `logs/` (ignored); demos/sweeps/tuning are validated locally.

Goals for this session
1) Remove Legacy API (m=2 path, no behavior change)
   - Refactor `dwolfe1_2obj.m` and `dwolfe2_2obj.m` (and their zoom helpers) to use dispatcher (no direct `f1/g1` calls).
   - Verify `qwolfe` path remains stable on the demo and sweep problems (hv/purity/gamma-delta reasonable).

2) Expand Problem Families
   - Add `VU1_f/g` wrappers with references/domains; map in dispatcher when applicable.
   - Optionally add `SP1_f/g` in the same style.

3) Registry
   - Extend `problems/registry.m` with selected present datasets from refs/problems.tex (BK1, VU1, SP1, etc.) including notes.

4) Validation
   - Re-run `experiments/run_vop_demo.m` and `experiments/run_vop_sweep.m`; compare hv/purity/gamma-delta vs prior logs.
   - Summarize any notable changes.

Instructions
- Work on branch `refactoring` and keep changes incremental.
- Use dispatcher for any new code that needs F/G; avoid adding new callsites of legacy `f*/g*`.
- Keep `G` as a 1×m cell array; `F` as m×1.
- Keep logs out of git; use `logs/*.txt` locally.
