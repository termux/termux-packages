# Changelog — ACP

All notable changes to this project will be documented in this file.

## [1.0.0] — 2026-06-23

### Added
- Core command: `acp "message"` wraps git add, commit, push
- Show mode: `-s` flag to preview commands before execution
- Safe mode: `--safe` flag blocks force push and warns on critical branches
- Security scanning: `--check` detects .env files, secrets, and large files
- Tag management: `--tag`, `--rm-tag`, `--tag-push`, `--tag-rm-push`
- Remote configuration: `--remote` to save custom git remote URL
- Config system: global defaults at `$PREFIX/etc/acp/default.conf`
- Comprehensive error messages with hints for common failures
- Cross-platform builds: Termux (ARM64, ARM, x86_64) and Linux desktop (x86_64, ARM64)
- GitHub Actions CI/CD with automated releases

### Security
- Input validation for all tag names (rejects shell injection attempts)
- Safe quoting for file paths with spaces and special characters
- Detection of sensitive files before they reach remote

### Quality
- Zero external C dependencies
- Compiled with `-Wall -Wextra -Werror` on all platforms
- Tested on real Termux/Android and Linux systems
