# Legacy API Migration — Tracking Checklist

Scope: remove direct uses of `f1/f2/f3` and `g1/g2/g3` in favor of the unified dispatcher API: `Ffun(x) -> m×1`, `Gfun(x) -> {g1..gm}`.

Owner: refactoring branch

- [x] Add dispatcher `src/core/problem_dispatcher.m` (TE8, FDS families mapped; legacy fallback)
- [x] Wire solver `src/core/vop_solve.m` to use dispatcher (eval/scale path)
- [x] Wire `src/core/hz_subproblem.m` to use dispatcher for g1/g2
- [x] Refactor `src/linesearch/qwolfe.m` (m=2) to use dispatcher
- [x] Deduplicate TE8/FDS families (`problems/te8_f/g.m`, `problems/fds_f/g.m`); delegate from `f*/g*`

Next (m=2 line-search internals)
- [ ] Convert `src/linesearch/dwolfe1_2obj.m` to use dispatcher (replace direct `f1/g1` reads)
- [ ] Convert `src/linesearch/dwolfe2_2obj.m` to use dispatcher
- [ ] Convert `src/linesearch/zoom11_2obj.m` and `zoom12_2obj.m` to use dispatcher
- [ ] Convert `src/linesearch/zoom21_2obj.m` and `zoom22_2obj.m` to use dispatcher
- [ ] Validate `qwolfe` end-to-end on demo/sweep after each conversion

Problem families & registry
- [ ] Add `problems/vu1_f.m` and `problems/vu1_g.m` (VU2001), include domain notes; map in dispatcher
- [ ] Add `problems/sp1_f.m` and `problems/sp1_g.m` (SP1997), include domain notes; map in dispatcher
- [ ] Migrate MOP5/MOP7 to family wrappers and delegate from `f*/g*`
- [ ] Extend `problems/registry.m` with selected present datasets and notes from `refs/problems.tex`

Validation & cleanup
- [ ] Re-run `experiments/run_vop_demo.m` and `experiments/run_vop_sweep.m`; compare hv/purity/gamma-delta to prior logs
- [ ] Remove legacy duplicates under `vector_optimization/*` (keep `.mat`)
- [ ] Decide if `f1/f2/f3` and `g1/g2/g3` remain as thin shims or deprecate (announce in README)

Notes
- Keep `G` as a 1×m cell array; `F` as m×1.
- Prefer shared helper for directional derivative evaluation in linesearch code to avoid duplication.

