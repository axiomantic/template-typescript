#!/usr/bin/env python3
"""Manual fallback for template-cleanup.

Find/replace `project-name` (kebab) and `project_name` (snake) placeholders
across the working tree, mirroring what `.github/workflows/template-cleanup.yml`
does on the first push to `main` of a repo created from this template.

Usage:
    python3 scripts/rename.py <new-kebab-name>
"""

from __future__ import annotations

import pathlib
import sys

# Directory names to skip entirely (build artifacts, VCS metadata, node_modules).
SKIP_DIRS = {"node_modules", "dist", ".astro", ".git", "coverage", ".vitest"}

# File extensions whose contents we rewrite. Everything in the scaffold that
# references the placeholders lives in one of these.
TEXT_SUFFIXES = {
    ".ts",
    ".tsx",
    ".mjs",
    ".cjs",
    ".js",
    ".json",
    ".md",
    ".mdx",
    ".yml",
    ".yaml",
    ".toml",
}

# Extensionless files we still want to rewrite (justfile, LICENSE, etc.).
TEXT_FILENAMES = {"justfile", "LICENSE", ".editorconfig", ".gitignore"}


def should_process(path: pathlib.Path) -> bool:
    if not path.is_file():
        return False
    if any(part in SKIP_DIRS for part in path.parts):
        return False
    if path.suffix in TEXT_SUFFIXES:
        return True
    return path.name in TEXT_FILENAMES


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: rename.py <new-kebab-name>", file=sys.stderr)
        return 2

    new_kebab = sys.argv[1]
    new_snake = new_kebab.replace("-", "_")
    root = pathlib.Path(".")

    rewritten = 0
    for path in root.rglob("*"):
        if not should_process(path):
            continue
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            # Binary file with a text-looking extension; skip.
            continue
        updated = original.replace("project_name", new_snake).replace(
            "project-name", new_kebab
        )
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            rewritten += 1

    print(f"Rewrote {rewritten} file(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
