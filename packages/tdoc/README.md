# TDOC — Termux Doctor

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Termux-blue.svg)
![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)
![Version](https://img.shields.io/github/v/release/djunekz/tdoc?color=blue)
---

## Table of Contents

- [About TDOC](#about-tdoc)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Commands](#commands)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)
- [Contact](#contact)

---

## About TDOC

**TDOC** (Termux Doctor) is a powerful CLI tool to **diagnose, fix, and manage your Termux environment**.  
It is designed for:

- Detecting broken packages, storage, repository settings, and more
- Automatic or manual fixes
- Generating JSON reports and system status
- Safe update via GitHub Release
- Professional UX with colors and spinners

TDOC is lightweight, open-source, and optimized for **Termux users and developers**.

---

## Features

- ✅ System scan (storage, repositories, Python, NodeJS, etc.)
- ✅ Manual / automatic fixes (`tdoc fix`, `tdoc fix --auto`)
- ✅ Status reports (`tdoc status`, `tdoc report`)
- ✅ Doctor JSON output (`tdoc doctor --json`)
- ✅ GitHub update (`tdoc update`, `tdoc update --check`)
- ✅ Professional CLI UX (colors, icons, spinners)
- ✅ Modular, configurable, and extendable

---

## Installation

```
pkg update && pkg upgrade
pkg install git curl tar
```
# Clone TDOC
```
git clone https://github.com/djunekz/tdoc
cd tdoc
```
# Make main script executable
```
chmod +x tdoc
```
# Optional: move to PATH
```
mv tdoc $PREFIX/bin/
```
---

## Commands Overview

- `tdoc status` = Show current system status
- `tdoc explain` = Detailed explanation of broken items
- `tdoc fix` = Run manual fix wizard
- `tdoc fix --auto` = Run automatic fix process
- `tdoc report` = Show raw system state report
- `tdoc doctor --json` = JSON output for integrations
- `tdoc security` = Repository security check
- `tdoc security --json` = JSON security output
- `tdoc help` = Show usage info
- `tdoc version` = Show version

---

## Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before submitting PRs or issues.
- Fork the repo
- Create a descriptive branch
- Submit a PR with detailed description
- Follow coding style & versioning

---

## License

TDOC is licensed under the `MIT License`.

For commercial or proprietary use, a separate commercial license is available.
See [COMMERCIAL_LICENSE.md](COMMERCIAL_LICENSE.md).

---

## Security

Please report security issues privately as described in [SECURITY.md](SECURITY.md).
Do not post exploits publicly.

---

## Security Model

TDOC is designed to be safe by default:

- No root access
- No background services
- No telemetry or network calls during scan
- No package installation/removal without user confirmation
- Repository verification uses official Termux mechanisms only

TDOC does not modify system state unless explicitly instructed by the user.

---
## Contact
TDOC Project Team
- 📧 djunekz@protonmail.com
- 🌐 GitHub: https://github.com/djunekz/tdoc
