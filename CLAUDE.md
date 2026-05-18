# project-name — Project Instructions

## Project Philosophy

This project follows axiomantic standards: production-quality or nothing,
audit-driven tooling, no shortcuts. Read this file before making changes.

## Build & Test Commands

The justfile is the canonical command surface. Don't memorize `npm` invocations.

| Task | Command | Notes |
|---|---|---|
| Run tests | `just test` | vitest |
| Lint | `just lint` | biome check + tsc --noEmit |
| Auto-format | `just fmt` | biome check --write |
| Build docs | `just docs` | astro dev (live reload) |
| Build dist | `just build` | tsup (ESM + CJS + .d.ts) |
| Pre-release smoke | `just release-preflight` | lint + test + build |

## Setup

1. Install Node `>=20` (e.g. via `nvm` or `mise`).
2. `npm ci`
3. `pre-commit install --install-hooks`   # requires Python's pre-commit; registers pre-commit AND pre-push hooks

## Key Conventions

- **Single entry:** all public exports live in `src/index.ts`.
- **Tests mirror src:** `tests/<name>.test.ts` mirrors `src/<name>.ts`.
- **Docstrings:** JSDoc; TypeDoc reads them for the docs API reference.
- **Type hints:** `@tsconfig/strictest` is in effect. No `any` without justification.
- **Formatting authority:** Biome. Do not hand-format.

## Forbidden Patterns

- No `any` in production code without a one-line justification comment.
- No blanket `try { ... } catch (e: unknown) {}` swallowing errors silently.
- No commented-out code. Delete or fix.
- No `// @ts-ignore` / `// @ts-expect-error` without a comment explaining why.
- No `console.log` in production code (use a logger or rethrow). Tests are exempt.

## Operational Notes

### OPENROUTER_KEY (org secret) — REQUIRED for pr-agent
The pr-agent.yml workflow consumes `secrets.OPENROUTER_KEY` from the repo or org level.
Verify with `gh secret list -o axiomantic | grep OPENROUTER_KEY` before opening the first PR.
Without it, pr-agent.yml fails on the first PR with no review output.

### Org Actions permissions
If your org disables Actions by default for new repos, enable Actions and grant write
permission to GITHUB_TOKEN before `template-cleanup.yml` runs (Settings -> Actions ->
General -> Workflow permissions -> "Read and write permissions"). Without this,
template-cleanup cannot push the rename commit and the marker file persists.

### `@devel` pin coupling — KNOWN LIVE RISK
`pr-agent.yml` inherits from `axiomantic/.github/.github/workflows/pr-agent.yml@devel`.
Breaking changes upstream propagate immediately to all instantiated repos. To pin
this project to a specific upstream SHA, replace `@devel` with the SHA in
`.github/workflows/pr-agent.yml`.

### npm publishing (OIDC + provenance)
`release.yml` runs `npm publish --provenance --access public` on tag push. Two
viable auth paths:

1. **Automation token (default):** set `NPM_TOKEN` repo secret to an npm automation
   token. The workflow's `id-token: write` permission still enables Sigstore
   provenance.
2. **npm trusted publisher (recommended long-term):** configure a trusted publisher
   at <https://www.npmjs.com/settings/axiomantic/packages/trusted-publishers> with
   workflow `release.yml` and environment `npm`. With trusted publisher configured,
   `NPM_TOKEN` is unnecessary.

### release-please flow
`release-please.yml` watches `main` for conventional commits and opens/updates a
release PR with the changelog + version bump. Merging the release PR creates a
git tag, which triggers `release.yml`.

## Glossary

(populate per project)
