# project-name

## Build Commands

| Task | Command |
|---|---|
| Test | `just test` |
| Lint | `just lint` |
| Format | `just fmt` |
| Docs | `just docs` |
| Build | `just build` |

## Architecture Overview

Single-package layout. Public API is exposed via `src/index.ts` and bundled by tsup
to `dist/` as dual ESM + CJS with `.d.ts` declarations.
Tests live in `tests/` and mirror the src tree.

## Key Modules

| Module | Purpose | Notes |
|---|---|---|
| `src/index.ts` | Package entry / public re-exports | All JSDoc here flows into the docs API reference |
| (add per project) | | |

## Conventions

- **Testing:** vitest, smoke tests in `tests/index.test.ts`.
- **Docstrings:** JSDoc; TypeDoc generates the API reference from these.
- **Formatting authority:** `biome format`. `biome check --write` for safe lint fixes.
- **Pre-commit guard:** `biome check --write` on every commit; `tsc --noEmit` on push.

## The justfile is the canonical command surface

`npm` and `tsup` are implementation details. Add new dev workflows as `just` recipes,
not as ad-hoc shell commands in README.
