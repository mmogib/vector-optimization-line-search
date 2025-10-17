# Problems

This project uses named problem wrappers and a central registry.

## Listing Problems
- Glossary (prints sorted names with brief refs):
  - `problem_glossary()`
  - `problem_glossary({'IKK1','TE8'})`
- Programmatic access:
  - `reg = registry();`  % fields: `name, n, m`

## Adding a New Problem
1) Add two files under `problems/`:
   - `<NAME>_f.m` — returns `F(x)` as an `m×1` vector.
   - `<NAME>_g.m` — returns a `1×m` cell `{g1(x),...,gm(x)}`.
   - Include: concise help header, I/O, domain constraints, short literature note.
2) Register it in `problems/registry.m` with default `n` and `m`.
3) Ensure `src/core/problem_dispatcher.m` recognizes the name (most cases follow `<name>_f/g` convention and work automatically).

## Datasets
- Place `.mat` files in `problems/data/` and load them from your problem functions using relative paths added by `setup`.
- Avoid absolute paths; use `addpath` in `setup` or a local, git-ignored `startup.m` if needed.

Notes
- Keep one public function per file; file name must match function name.
- Follow 2-space indentation and ≤100 chars per line.

