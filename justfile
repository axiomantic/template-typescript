default:
    @just --list

# Run the test suite
test:
    npm test

# Lint (biome check + tsc typecheck)
lint:
    npm run lint
    npm run typecheck

# Auto-fix formatting and lint where possible
fmt:
    npm run fmt

# Build and serve docs locally (assumes `npm ci` has already run in docs/)
docs:
    cd docs && [ -d node_modules ] || npm install
    cd docs && npm run dev

# Build distribution
build:
    npm run build

# Pre-publish smoke check (run before tagging a release)
release-preflight:
    just lint
    just test
    just build

# Manual fallback for template-cleanup (find/replace project_name -> kebab name).
rename new_name:
    @echo "Renaming project-name -> {{new_name}}"
    @python3 scripts/rename.py "{{new_name}}"

# Remove build artifacts and caches
clean:
    rm -rf dist node_modules docs/node_modules docs/.astro docs/dist coverage
