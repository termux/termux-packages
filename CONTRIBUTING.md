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

In most cases it is strightforward modification of build script with chaning variables `TERMUX_PKG_VERSION` and
`TERMUX_PKG_SHA256`.

`TERMUX_PKG_VERSION` is a text string that represents a full package version in this format:
```
{EPOCH}:{PROJECT VERSION}
```
In most cases you need to change only the `{PROJECT VERSION}`. `{EPOCH}` is used only in rare cases such as downgrading or
versioning scheme change.

You may see a `TERMUX_PKG_REVISION` variable in a `build.sh` file. Remove it when package is upgraded.

`TERMUX_PKG_SHA256` is a SHA-256 checksum of the source code archive downloaded from the URL specified with `TERMUX_PKG_SRCURL`.

More about `build.sh` variables you can read in [developer's wiki](https://github.com/termux/termux-packages/wiki/Creating-new-package#table-of-available-package-control-fields).

Example of package upgrading: https://github.com/termux/termux-packages/commit/fbcaa06ecc2797db77a19e2821906144b2928863.

Important: if package has patches, ensure that they can be applied to updated source bundle. Otherwise we may reject your
pull request.
