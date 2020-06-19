# Contributing

Termux is an open source application and it is built on users' contributions. However, most of work is done by Termux
maintainers on their spare time and therefore only priority tasks are being completed.

Here are ways how you can help:
- [Fixing issues](#fixing-issues)
- [Hosting a mirror](#hosting-a-mirror)
- [Updating packages](#updating-packages)

Developer's wiki is available in https://github.com/termux/termux-packages/wiki.

## Fixing issues

By fixing bugs you will ensure that Termux packages are running smoothly. Pay attention to [issues](https://github.com/termux/termux-packages/issues) labeled as ["bug report"](https://github.com/termux/termux-packages/issues?q=is%3Aopen+is%3Aissue+label%3A%22bug+report%22) and
["help wanted"](https://github.com/termux/termux-packages/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22). Note that
solution for these issues may not be easy.

### A note about package requests

We tend not to package everything what was requested, but making exception for packages that we consider important. If you
want to submit a package, make sure that following conditions are met:
- Package should have widely recognised OSS licenses like GNU GPL, MIT, Apache-2.0 and similar.
- Package should NOT be an outdated, dead project.
- Package should NOT be a part of language-specific ecosystem. Such packages are installable through `pip`, `gem`, `cpan`, `npm`.

We will reject requests for packaging single-file scripts. Also we may not package infamous projects as we need to be sure
that package is used by other people, not just by someone who requested it.

## Hosting a mirror

Our APT repositories are receiving large amount of downloads per day. You can create own public mirror to help to deal with
large amount of traffic.

Requirements for a server where mirror will be hosted:
- At least 20 GB of free space on HDD.
- Unlimited traffic, otherwise 3 TB monthly bandwidth + caching CDN.
- Cron job for updating mirror at least once in 24 hours.

Software: you can use any utility (for example `apt-mirror`) for mirroring APT repositories as soon as it doesn't change
the file structure. Hash sums and signatures must be original, otherwise GPG verification will not be passed.

Origin URLs for mirroring:
```
https://dl.bintray.com/termux/termux-packages-24
https://dl.bintray.com/grimler/game-packages-24
https://dl.bintray.com/grimler/science-packages-24
https://dl.bintray.com/grimler/termux-root-packages-24
https://dl.bintray.com/xeffyr/unstable-packages
https://dl.bintray.com/xeffyr/x11-packages
```

Once your mirror is ready, open the issue so it will be added to the [list](https://github.com/termux/termux-packages/wiki/Mirrors).

## Updating packages

Keeping packages up-to-date ensures that Termux users' will not experience the upstream bugs or security issues and will be
able to use the latest features.

Periodically check the [Repology](https://repology.org/projects/?inrepo=termux&outdated=1) page to see what is outdated and
submit a pull request with version update.

### How to update package

[![asciicast](https://asciinema.org/a/gVwMqf1bGbqrXmuILvxozy3IG.svg)](https://asciinema.org/a/gVwMqf1bGbqrXmuILvxozy3IG?autoplay=1&speed=2.0)

Most packages can be updated by just modifying variables `TERMUX_PKG_VERSION` and `TERMUX_PKG_SHA256`.

`TERMUX_PKG_VERSION`: a text field containing an original version of package.
`TERMUX_PKG_SHA256`: a text field or an array of text fields containing SHA-256 checksum for each source code bundle defined by `TERMUX_PKG_SRCURL`.

More about `build.sh` variables you can read in [developer's wiki](https://github.com/termux/termux-packages/wiki/Creating-new-package#table-of-available-package-control-fields).

#### Rebuilding package with no version change

Changes to patch files and build configuration options require submission of a new package release with a different version string. As we can't
modify the original package version, we append a number called *revision*. This number should be incremented on each submitted build whenever
project's version remains to be same.

Revision is specified through `TERMUX_PKG_REVISION` build.sh variable. To have build.sh script easily readable, we require revision variable to
be placed on the next line after `TERMUX_PKG_VERSION`.

```
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=4
```

#### Downgrading a package or changing versioning scheme

Sometimes we need to downgrade a package or in any other way to change format of version string but we also need to tell package manager that
this is a new package version which should be installed with `apt upgrade`. To force new build to be a package update, we set a *package epoch*.

We don't have separate build.sh variable for specifying epoch, so we doing that through `TERMUX_PKG_VERSION` variable. It takes following
format:
```
${EPOCH}:${ORIG_VERSION}
```

Epoch should be bumped on each change of versioning scheme or downgrade.

```
TERMUX_PKG_VERSION=1:0.5
TERMUX_PKG_REVISION=4
```

Note that if you are not @termux collaborator, pull request must contain a *description* why you are submitting a package downgrade.
All pull requests which submit package downgrading without any serious reason will be denied.

#### Dealing with patch errors

Major changes introduced to packages often make current patches incompatible with newer package version. Unfortunately, there no
universal guide about fixing patch issues as workaround is always based on changes introduced to the new source code version.

Here are few things you may to try:

1. If patch fixing particular known upstream issue, check the project's VCS for commits fixing the issue. There is a chance that
   patch is no longer needed.

2. Inspecting the failed patch file and manually applying changes to source code. Do so only if you understand the source code
   and changes introduced by patch.

   Regenerate patch file, e.g. with:
   ```
   diff -uNr package-1.0 package-1.0.mod > previously-failed-patch-file.patch
   ```

Always check the CI (Github Actions) status for your pull request. If it fails, then either fix or close it. Maintainers can
fix it on their own, if issues are minor. But they won't rewrite whole your submission.
