# Kickoff Prompt: Next Session

Context
- Dispatcher-based F/G with params is stable; vop_solve uses unified direction and line-search APIs.
- Directions: SD/PRP/HZ unified; HZ adaptive update now lives inside `direction_hz` and passes history back to the solver.
- Line-searches: DWOLFE and QWOLFE are unified with documented wrappers; all legacy zoom/dwolfe variants removed.
- Experiments target the P-set (IKK1/TE8/MOP5/MOP7/SLCDT2); HZ + Wolfe settings converge decisively. Logs are under `logs/` (ignored).

Goals for this session
1) Polish Directions
   - Confirm/document HZ defaults in code/comments (hz_mu=1, hz_c=0.2, hz_ita=1e-2).
   - Add PRP+ niceties: beta capping (e.g., min(beta, 10)) and optional restart hook.

2) Improve Demo/Sweep UX & Metrics
   - Add optional hv booster: collect intermediate F every K iterations (e.g., K=5) via a solver option (recordIntermediateEvery).
   - Tidy metric printing for tiny sets (avoid purity=Inf/NaN formatting surprises).

3) Final Pass
   - Ensure consistent headers and “Refactored by: Dr. Mohammed Alshahrani” across src/directions and src/linesearch.
   - Confirm demo/sweep/hz_tuning remain -batch friendly and documented.

Suggested Next Steps
- Implement PRP+ beta capping and optional restart.
- Add recordIntermediateEvery to vop_solve, wire into demo option for optional hv boost.
- Refine metric printing for small sets and re-run demo/sweep; summarize diffs.

Notes
- Core consolidation (dispatcher, linesearch, directions) is complete; remaining tasks are polish and optional UX improvements.
