# Copilot instructions

- Ask the user before adding anything to this file.
- Read `TEMPERED.md` before changing configs; log every change there with its motivation, Difficulty, and Save columns.
- When editing an upstream config line, keep its comment and prefix it with `[tempered] upstream: <old value>.`; list edits with `grep -rn '\[tempered\]' include src data`.
  When merging upstream changes, update these `upstream:` values (and `TEMPERED.md`) if upstream changed a default.
- Validate changes with `make -j$(nproc)` and `make check -j$(nproc)`, always run in a background subagent so the main session isn't blocked; the baseline has 0 test failures.
