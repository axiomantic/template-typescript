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

# Build and serve docs locally
docs:
    cd docs && npm install && npm run dev

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
    @python3 -c "import sys, pathlib; new_kebab = sys.argv[1]; new_snake = new_kebab.replace('-', '_'); root = pathlib.Path('.'); [f.write_text(f.read_text(encoding='utf-8').replace('project_name', new_snake).replace('project-name', new_kebab), encoding='utf-8') for f in root.rglob('*') if f.is_file() and not any(p.startswith('.') or p == 'node_modules' or p == 'dist' or p == '.astro' for p in f.parts) and f.suffix in {'.ts', '.tsx', '.mjs', '.cjs', '.js', '.json', '.md', '.mdx', '.yml', '.yaml', '.toml'}]" {{new_name}}

# Remove build artifacts and caches
clean:
    rm -rf dist node_modules docs/node_modules docs/.astro docs/dist coverage
