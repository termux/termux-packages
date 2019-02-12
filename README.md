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

## Resources
- [Android changes for NDK developers](https://android.googlesource.com/platform/bionic/+/master/android-changes-for-ndk-developers.md)

- [Linux From Scratch](http://www.linuxfromscratch.org/lfs/view/stable/)

- [Beyond Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/stable/)

- [OpenWrt](https://openwrt.org/) as an embedded Linx distribution contains [patches and build scripts](https://dev.openwrt.org/browser/packages)

- [Kivy recipes](https://github.com/kivy/python-for-android/tree/master/pythonforandroid/recipes) contains recipes for building packages for Android.
