# Repository Guidelines

## Project Structure & Module Organization
`termux-packages` is recipe-driven. Most work happens in:
- `packages/`: main package recipes (`<pkg>/build.sh`, patches, optional `tests/`).
- `root-packages/`: recipes intended for rooted environments.
- `x11-packages/`: X11/Desktop-oriented packages.
- `disabled-packages/`: temporarily excluded recipes.
- `scripts/`: build, lint, Docker, update, and CI helper scripts.
- `ndk-patches/`: Android NDK compatibility patches.
- `output/`: generated package artifacts.

Package directory names should match the package name and stay lowercase.

## Build, Test, and Development Commands
- `./build-package.sh -a aarch64 packages/<name>`: build one recipe for a target arch.
- `./build-package.sh -I -C -a aarch64 <name>`: CI-like build flags (install deps, cleanup).
- `./scripts/run-docker.sh ./build-package.sh -I -C -a aarch64 <name>`: run build in containerized environment.
- `./scripts/lint-packages.sh packages/<name>/build.sh`: lint recipe style and metadata.
- `./scripts/test-runner.sh <name>`: run package tests from `packages/<name>/tests`.
- `./clean.sh`: clear build state/cache when switching tasks.

## Coding Style & Naming Conventions
Build recipes are Bash. Follow existing `TERMUX_PKG_*` variable conventions and keep metadata deterministic (`TERMUX_PKG_VERSION`, `TERMUX_PKG_SRCURL`, `TERMUX_PKG_SHA256`).

Lint enforces indentation rules in recipes: use tabs for indentation in `build.sh` (avoid mixed indentation). Keep patch names descriptive and standard (`*.patch`, with optional variants like `.patch32`, `.patch64`, `.patch.debug`).

## Testing Guidelines
Place tests under `packages/<name>/tests/`. `scripts/test-runner.sh` sources each test file and provides `assert_equals`. Write small, deterministic shell tests that fail fast.

Before opening a PR, run lint and tests for every changed package and verify the package builds for at least one relevant architecture.

## Commit & Pull Request Guidelines
Prefer concise commit subjects. Common pattern for version bumps:
- `bump(main/<package>): <version>`

For non-bump changes, use scoped subjects like:
- `scripts/<file>: fix <behavior>`

PRs should include: purpose, affected packages, target architecture(s) tested, and relevant issue links. Avoid disruptive bulk edits or unrelated reverts.

## Security & Configuration Tips
Do not hardcode host FHS paths in recipes. Use Termux paths/variables and keep source URLs/checksums reproducible.
