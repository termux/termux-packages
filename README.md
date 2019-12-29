# Termux packages

[![build status](https://api.cirrus-ci.com/github/termux/termux-packages.svg?branch=android-5)](https://cirrus-ci.com/termux/termux-packages)
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

**Warning:** android-5 branch is now discontinued. Do not post any issues regarding
this branch.

This project contains scripts and patches to build packages for the
[Termux](https://termux.com/) Android application. Note that on-device
package building is supported only partially for now.

More information can be found in the project's [Wiki](https://github.com/termux/termux-packages/wiki).

## Directory Structure

- [disabled-packages](disabled-packages/):
  packages that cannot be built or have serious issues.

- [ndk-patches](ndk-patches/):
  patches for Android NDK headers.

- [packages](packages/):
  all currently available packages.

- [scripts](scripts/):
  utility scripts for building.

## Contacts

- General Mailing List: https://groups.io/g/termux

- Developer Mailing List: https://groups.io/g/termux-dev

- Developer Chat: https://gitter.im/termux/dev or #termux/development on IRC/freenode.

If you are interested in our weekly development sessions, please check the
https://wiki.termux.com/wiki/Dev:Development_Sessions. Also, you may want to
check the https://wiki.termux.com/wiki/Development.
