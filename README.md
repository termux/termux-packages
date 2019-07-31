# Termux packages

[![Powered by JFrog Bintray](./.github/static/powered-by-bintray.png)](https://bintray.com)

[![build status](https://api.cirrus-ci.com/github/termux/termux-packages.svg?branch=master)](https://cirrus-ci.com/termux/termux-packages)
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to build packages for the
[Termux](https://termux.com/) Android application. Note that packages are
cross-compiled and on-device builds are not currently supported.

More information can be found in the [docs](docs/) directory.

## Directory Structure

- [disabled-packages](disabled-packages/):
  packages that cannot be built or have serious issues.

- [docs](docs/):
  documentation on how to build, formatting etc.

- [ndk-patches](ndk-patches/):
  patches for Android NDK headers.

- [packages](packages/):
  all currently available packages.

- [scripts](scripts/):
  utility scripts for building.

## Issues

The two most common types of issues are package requests and bug reports. There
are already templates available.

You can open an issue for any package or build problems. For example, if you
observing crashes or other kind of malfunction, you are certainly welcome to
file an issue.

Also, if you want to request a particular package, you may suggest it in an
issue. However, be prepared that package may not be available shortly. Bugfixes
and improvements take precedence over new packages.

### Information for Android 7+ users

If your device running Android OS with version 7 and higher, it is highly
recommended to check whether your Termux installation uses our new repository
with packages compiled specially for higher Android API levels (24+).

Execute following command:
```
grep termux-packages-24 $PREFIX/etc/apt/sources.list
```
It should output the line containing this URL:
```
https://dl.bintray.com/termux/termux-packages-24/
```
If not, then it is time to upgrade your installation. This procedure will
involve complete erasing of `$PREFIX`, directory where all packages are
installed (aka rootfs) but your home directory will be untouched.

So if you decided to upgrade your installation, do the following steps:

1. Ensure that application's version is v0.67 or higher. If not - upgrade.

2. Move all important files, e.g. configs, databases, custom scripts, etc to
   your `$HOME` (temporarily). Also, save the list of packages that you will
   need to reinstall.

3. Execute `rm -rf $PREFIX`.

4. Restart Termux application.

5. Restore all your stuff saved in step 2.

## Pull Requests

We welcome any pull requests. Nevertheless, a log file should be provided in
order to show that it is at least working.

All pull requests will be built by [Cirrus CI](https://cirrus-ci.com/termux/termux-packages).
Usually, it is expected that all tasks will pass. But do not worry if CI build
timed out. Alternatively, you can provide build logs by yourself.

Note that it is highly recommended to keep your pull requests up-to-date. If
you do not know how to do this, take a look on manpage of `git-rebase`.

## Contacts

- General Mailing List: https://groups.io/g/termux

- Developer Mailing List: https://groups.io/g/termux-dev

- Developer Chat: https://gitter.im/termux/dev or #termux/development on IRC/freenode.

If you are interested in our weekly development sessions, please check the
https://wiki.termux.com/wiki/Dev:Development_Sessions. Also, you may want to
check the https://wiki.termux.com/wiki/Development.
