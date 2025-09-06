# Termux Packages

![GitHub repo size](https://img.shields.io/github/repo-size/termux/termux-packages) &nbsp;&nbsp;
[![Packages last build status](https://github.com/termux/termux-packages/actions/workflows/packages.yml/badge.svg?branch=master)](https://github.com/termux/termux-packages/actions/workflows/packages.yml) &nbsp;&nbsp;
[![Docker image status](https://github.com/termux/termux-packages/workflows/Docker%20image/badge.svg)](https://hub.docker.com/r/termux/package-builder) &nbsp;&nbsp;
[![Repology metadata](https://github.com/termux/repology-metadata/workflows/Repology%20metadata/badge.svg)](https://repology.org/repository/termux) &nbsp;&nbsp;

[![Repository status](https://repology.org/badge/repository-big/termux.svg)](https://repology.org/repository/termux)
---

## Community & Support

Join our community channels:

[![Discord](https://img.shields.io/discord/641256914684084234.svg?label=&logo=discord&logoColor=ffffff&color=5865F2)](https://discord.gg/HXpF69X)  
[![Matrix](https://img.shields.io/badge/Matrix-%E2%80%8B?style=plastic&logo=matrix&logoColor=white&color=green)](https://matrix.to/#/#Termux:matrix.org)  
[![Telegram](https://img.shields.io/badge/Telegram-%E2%80%8B?style=plastic&logo=telegram&logoColor=white&color=blue)](https://t.me/termux24x7)  
[![Reddit](https://img.shields.io/badge/Reddit-%E2%80%8B?style=plastic&logo=reddit&logoColor=white&color=red)](https://www.reddit.com/r/termux/)

**Community Guidelines:**  
All members must follow [Rules](https://github.com/termux/termux-community/blob/site/site/pages/en/rules/index.md) and avoid posting content defined as [Not Allowed](https://github.com/termux/termux-community/blob/site/site/pages/en/rules/index.md#8-content-not-allowed).

---

## About Termux Packages

This repository contains scripts and patches to build packages for the [Termux](https://github.com/termux/termux-app) Android application.

Quick start guide on package management, including fixing `repository is under maintenance or down` errors, is available [here](https://github.com/termux/termux-packages/wiki/Package-Management).

### Notes on Android 13+  
- Some packages may require updated API or library paths.  
- Refer to the [Android Compatibility Wiki](https://github.com/termux/termux-packages/wiki/Android-13) for details.  

---

## Building Packages

- Packages are built using scripts in this repository.  
- CI/CD builds run on GitHub Actions and Docker, ensuring reproducible builds for Termux packages.  
- Detailed instructions for creating or updating packages are available in the [Developer Wiki](https://github.com/termux/termux-packages/wiki).

---

## Contributing

We welcome contributions! Please follow these guidelines:

1. Read the [CONTRIBUTING.md](https://github.com/termux/termux-packages/blob/master/CONTRIBUTING.md) file.  
2. Check our [Developer Wiki](https://github.com/termux/termux-packages/wiki) for package creation and patching instructions.  
3. Ensure your contributions pass CI/CD checks before submission.

---

## Hosting

This repository is hosted by Hetzner:

<img src=".github/static/hosted-by-hetzner.png" alt="Hosted by Hetzner" width="128px">

---

## Additional Resources

- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)  
- [Package Management Wiki](https://github.com/termux/termux-packages/wiki/Package-Management)  
- [Community Docs](https://github.com/termux/termux-community/blob/site/site/pages/en/index.md)  
- [CI/CD Status](https://github.com/termux/termux-packages/actions)

---

**Maintainers:**  
- Termux community contributors  
- GitHub Actions ensure automated package building and validation
