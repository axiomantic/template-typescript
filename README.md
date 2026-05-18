# project-name

[![npm version](https://img.shields.io/npm/v/@axiomantic/project-name.svg)](https://www.npmjs.com/package/@axiomantic/project-name) [![npm downloads](https://img.shields.io/npm/dm/@axiomantic/project-name.svg)](https://www.npmjs.com/package/@axiomantic/project-name) [![CI](https://github.com/axiomantic/project-name/actions/workflows/ci.yml/badge.svg)](https://github.com/axiomantic/project-name/actions/workflows/ci.yml) [![License](https://img.shields.io/npm/l/@axiomantic/project-name.svg)](./LICENSE) [![Types](https://img.shields.io/npm/types/@axiomantic/project-name.svg)](https://www.npmjs.com/package/@axiomantic/project-name) [![Node](https://img.shields.io/node/v/@axiomantic/project-name.svg)](https://www.npmjs.com/package/@axiomantic/project-name)

PROJECT DESCRIPTION HERE.

## After using this template

1. Push to `main` — `.github/workflows/template-cleanup.yml` will rewrite `project-name`
   (kebab) and `project_name` (snake) placeholders to the new repo name, remove the
   marker, and commit. Manual fallback: `just rename foo-bar`.
2. Update `package.json` `description`, `keywords`, and verify URLs.
3. Replace this README with real content.
4. PR Agent runs automatically via the org-level `OPENROUTER_KEY` secret on `axiomantic`. If you forked into a different namespace, set the secret yourself or remove `.github/workflows/pr-agent.yml`.

## Development

```bash
npm ci
just test
just lint
just docs
```

## Operational Notes

### Justfile is the canonical command surface

All dev workflows route through `just`:

- `just test` — vitest
- `just lint` — biome check + tsc --noEmit
- `just fmt` — auto-format with biome
- `just docs` — Astro Starlight dev server
- `just build` — tsup (ESM + CJS + .d.ts)
- `just release-preflight` — lint + test + build

`npm` and `tsup` are implementation details. Add new dev workflows as `just`
recipes, not as ad-hoc shell commands here.

### OPENROUTER_KEY org secret

`.github/workflows/pr-agent.yml` requires `OPENROUTER_KEY` at the org level
(or per-repo). Verify with:

```bash
gh secret list -o axiomantic | grep OPENROUTER_KEY
```

Without it, the first PR will fail in `pr-agent` with no review output.

### Org Actions permissions

If your org disables Actions by default for new repos, enable Actions and
grant write permission to `GITHUB_TOKEN` before `template-cleanup.yml` runs:
**Settings -> Actions -> General -> Workflow permissions -> "Read and write
permissions"**. Without this, template-cleanup cannot push the rename commit
and the marker file persists.

### npm publishing (one-time per project)

`release.yml` runs `npm publish --provenance --access public` on tag push. Two
viable auth paths:

1. **Automation token (default):** set repo secret `NPM_TOKEN` to an npm automation
   token. OIDC provenance still works via `id-token: write`.
2. **npm trusted publisher (recommended):** configure at
   <https://www.npmjs.com/settings/axiomantic/packages/trusted-publishers> with
   workflow `release.yml` and environment `npm`. Removes the need for `NPM_TOKEN`.

### Release flow

- Conventional commits to `main` -> `release-please.yml` opens/updates a release PR.
- Merging the release PR creates tag `vX.Y.Z` -> `release.yml` publishes to npm.

### GitHub Pages

`docs.yml` deploys `docs/dist/` to GitHub Pages. Enable Pages in repo settings
(Settings -> Pages -> Source: GitHub Actions) before the first run.

## License

MIT
