# Termux packages

[![Packages last build status](https://github.com/termux/termux-packages/workflows/Packages/badge.svg)](https://github.com/termux/termux-packages/actions)
[![Docker image status](https://github.com/termux/termux-packages/workflows/Docker%20image/badge.svg)](https://hub.docker.com/r/termux/package-builder)
[![Repology metadata status](https://github.com/termux/termux-packages/workflows/Repology%20metadata/badge.svg)](https://repology.org/repository/termux)
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

[![Powered by JFrog Bintray](./.github/static/powered-by-bintray.png)](https://bintray.com)

This project contains scripts and patches to build packages for the [Termux]
Android application.

The packages available here are only from main set. We have some additional
repositories:

- https://github.com/termux/game-packages

  Game packages, e.g. `angband` or `moon-buggy`.

- https://github.com/termux/science-packages

  Science-related packages like `gap` and `gnucap`.

- https://github.com/termux/termux-root-packages

  Packages which can be used only on rooted devices. Some stuff available
  here requires custom kernel (like `aircrack-ng` or `lxc`).

- https://github.com/termux/unstable-packages

  Staging repository. Packages that are not stable are only available here.Most likely, new packages will also be placed here.

- https://github.com/termux/x11-packages

  Packages that require X11 Windows System.

Termux package management quick how-to available on https://wiki.termux.com/wiki/Package_Management.
To learn about using our build environment, read the [Developer's Wiki].

## Project structure

Directories:

- [disabled-packages](disabled-packages/):

  Packages that cannot be published due to serious issues.

- [ndk-patches](ndk-patches/):

  Our changes to Android NDK headers.

- [packages](packages/):

  Main set of packages.

- [sample](sample/):

  Sample structure for creating new packages.

- [scripts](scripts/):

  Set of utilities and build system scripts.

## Contributing

### Bug reports

Please, use templates for submitting bug reports. The *bug report* issue template
can be initialized by clicking on https://github.com/termux/termux-packages/issues/new?template=bug_report.md.

General requirements for bug reports are:

- All packages are up-to-date.

- Problem is not related to third-party software.

- Output of `termux-info` attached.

- Be ready to provide more info if requested.

### New packages

Use the *package request* template: https://github.com/termux/termux-packages/issues/new?template=package_request.md.

General requirements for new packages are:

- Packages should be open source and have widely recognised OSS licenses like
  GNU GPL.

- Packages should not be installable via language-specific package managers such
  as `gem`, `pip` or `cpan`.

- Packages should not be outdated dead projects.

- Be ready that your package request will not be processed immediately.

## Pull Requests

All pull requests are welcome.

We use [Github Actions](https://github.com/termux/termux-packages/actions) for processing
all pushes including pull requests. All build logs and artifacts are public, so you can
verify whether your changes work properly.

People who are new for packaging can begin with sending PRs for updating
packages. Check the outdated packages on https://repology.org/projects/?inrepo=termux&outdated=1.

Get started with information available on [Developer's Wiki].

## Contacts

- General Mailing List: https://groups.io/g/termux

- Developer Mailing List: https://groups.io/g/termux-dev

- Developer Chat: https://gitter.im/termux/dev or #termux/development on IRC/freenode.

If you are interested in our weekly development sessions, please check the
https://wiki.termux.com/wiki/Dev:Development_Sessions. Also, you may want to
check the https://wiki.termux.com/wiki/Development.

[Bintray]: <https://bintray.com/termux/termux-packages-24>
[Developer's Wiki]: <https://github.com/termux/termux-packages/wiki>
[Termux]: <https://github.com/termux/termux-app>
[android-5]: <https://github.com/termux/termux-packages/tree/android-5>
[master]: <https://github.com/termux/termux-packages/tree/master>
