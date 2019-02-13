# Termux packages

[![pipeline status](https://gitlab.com/termux-mirror/termux-packages/badges/master/pipeline.svg)](https://gitlab.com/termux-mirror/termux-packages/commits/master)
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to build packages for the [Termux](https://termux.com/) Android application. Note that packages are cross compiled and that on-device builds are not currently supported.

More information can be found in the [docs/](docs/) directory.

## Directory Structure

- [disabled-packages](disabled-packages/): Packages that cannot build or are currently disused.

- [docs](docs/): Documentation on how to build, formatting etc.

- [ndk-patches](ndk-patches/): C Header patches of the Android NDK.

- [packages](packages/): All currently available packages.

- [scripts](scripts/): Utility scripts for building.

## Issues

The two most common types of issues are package requests and bug reports. There are already templates available.

You can open an issue for any package or build problems. For example, if there are segmentation faultd or cashes, you are certainly welcome to file an issue.

Also, if you have a package request, you may suggest it in an issue. However, be prepared that we may not be able to provide the package shortly as most contributors are busier and busier.

## Pull Requests

We welcome any pull requests. Nevertheless, a log file should be provided in order to show that it is at least working.

Normally, all pull requests will be tested by [Travis CI](https://travis-ci.org/termux/termux-packages). However, in case if you are banned or for whatever reason do no use Travis CI, you should provide a log file by yourself.

All tests for master branch are now done in Gitlab CI.

## Mailing Lists

- [General Mailing List](https://groups.io/g/termux)

- [Developer Mailing List](https://groups.io/g/termux-dev) (not yet in operation)
