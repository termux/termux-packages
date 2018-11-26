Termux packages
===============
[![Build Status](https://travis-ci.org/termux/termux-packages.svg?branch=master)](https://travis-ci.org/termux/termux-packages)
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to build packages for the [Termux](https://termux.com/) Android application. Note that packages are cross compiled and that on-device builds are not currently supported.

Setting up a build environment using Docker
===========================================
For most people the best way to obtain an environment for building packages is by using Docker. This should work everywhere Docker is supported (replace `/` with `\` if using Windows) and ensures an up to date build environment that is tested by other package builders.

Run the following script to setup a container (from an image created by [scripts/Dockerfile](scripts/Dockerfile)) suitable for building packages:

    ./scripts/run-docker.sh

This source folder is mounted as the `/root/termux-packages` data volume, so changes are kept
in sync between the host and the container when trying things out before committing, and built
deb files will be available on the host in the `debs/` directory just as when building on the host.

The docker container used for building packages is a Ubuntu installation with necessary packages
pre-installed. The default user is a non-root user to avoid problems with package builds modifying the system
by mistake, but `sudo` can be used to install additional Ubuntu packages to be used during development.

Build commands can be given to be executed in the docker container directly:

    ./scripts/run-docker.sh ./build-package.sh libandroid-support

will launch the docker container, execute the `./build-package.sh libandroid-support`
command inside it and afterwards return you to the host prompt, with the newly built
deb in `debs/` to try out.

Note that building packages can take up a lot of space (especially if `build-all.sh` is used to build all packages) and you may need to [increase the base device size](http://www.projectatomic.io/blog/2016/03/daemon_option_basedevicesize/) if running with a storage driver using a small base size of 10 GB.

Build environment without Docker
================================
If you can't run Docker you can use a Ubuntu 18.10 installation (either by installing a virtual maching guest or on direct hardware) by using the below scripts:

- Run `scripts/setup-ubuntu.sh` to install required packages and setup the `/data/` folder.

- Run `scripts/setup-android-sdk.sh` to install the Android SDK and NDK at `$HOME/lib/android-{sdk,ndk}`.

There is also a [Vagrantfile](scripts/Vagrantfile) available as a shortcut for setting up an Ubuntu installation with the above steps applied.

Building a package
==================
The basic build operation is to run `./build-package.sh $PKG`, which:

1. Sets up a patched stand-alone Android NDK toolchain if necessary.

2. Reads `packages/$PKG/build.sh` to find out where to find the source code of the package and how to build it.

3. Extracts the source in `$HOME/.termux-build/$PKG/src`.

4. Applies all patches in packages/$PKG/\*.patch.

5. Builds the package under `$HOME/.termux-build/$PKG/` (either in the build/ directory there or in the
  src/ directory if the package is specified to build in the src dir) and installs it to `$PREFIX`.

6. Extracts modified files in `$PREFIX` into `$HOME/.termux-build/$PKG/massage` and massages the
  files there for distribution (removes some files, splits it up in sub-packages, modifies elf files).

7. Creates a deb package file for distribution in `debs/`.

Reading [build-package.sh](build-package.sh) is the best way to understand what is going on.

Additional utilities
====================
* build-all.sh: used for building all packages in the correct order (using buildorder.py).

* clean.sh: used for doing a clean rebuild of all packages.

* scripts/check-pie.sh: Used for verifying that all binaries are using PIE, which is required for Android 5+.

* scripts/check-versions.sh: used for checking for package updates.
	
* scripts/list-packages.sh: used for listing all packages with a one-line summary.


Resources
=========
* [Android changes for NDK developers](https://android.googlesource.com/platform/bionic/+/master/android-changes-for-ndk-developers.md)

* [Linux From Scratch](http://www.linuxfromscratch.org/lfs/view/stable/)

* [Beyond Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/stable/)

* [OpenWrt](https://openwrt.org/) as an embedded Linx distribution contains [patches and build scripts](https://dev.openwrt.org/browser/packages)

* [Kivy recipes](https://github.com/kivy/python-for-android/tree/master/pythonforandroid/recipes) contains recipes for building packages for Android.


Common porting problems
=======================
* The Android bionic libc does not have iconv and gettext/libintl functionality built in. A `libandroid-support` package contains these and may be used by all packages.

* "error: z: no archive symbol table (run ranlib)" usually means that the build machines libz is used instead of the one for cross compilation, due to the builder library -L path being setup incorrectly

* rindex(3) does not exist, but strrchr(3) is preferred anyway.

* &lt;sys/termios.h&gt; does not exist, but &lt;termios.h&gt; is the standard location.

* &lt;sys/fcntl.h&gt; does not exist, but &lt;fcntl.h&gt; is the standard location.

* &lt;sys/timeb.h&gt; does not exist (removed in POSIX 2008), but ftime(3) can be replaced with gettimeofday(2).

* &lt;glob.h&gt; does not exist, but is available through the `libandroid-glob` package.

* SYSV shared memory is not supported by the kernel. A `libandroid-shmem` package, which emulates SYSV shared memory on top of the [ashmem](http://elinux.org/Android_Kernel_Features#ashmem) shared memory system, is available. Use it with `LDFLAGS+=" -landroid-shmem`.

* SYSV semaphores is not supported by the kernel. Use unnamed POSIX semaphores instead (named semaphores are unimplemented).

dlopen() and RTLD&#95;&#42; flags
=================================
&lt;dlfcn.h&gt; declares

    RTLD_NOW=0; RTLD_LAZY=1; RTLD_LOCAL=0; RTLD_GLOBAL=2;       RTLD_NOLOAD=4; // 32-bit
    RTLD_NOW=2; RTLD_LAZY=1; RTLD_LOCAL=0; RTLD_GLOBAL=0x00100; RTLD_NOLOAD=4; // 64-bit

These differs from glibc ones in that

1. They differ in value from glibc ones, so cannot be hardcoded in files (DLFCN.py in python does this)
2. They are missing some values (`RTLD_BINDING_MASK`, ...)

Android Dynamic Linker
======================
The Android dynamic linker is located at `/system/bin/linker` (32-bit) or `/system/bin/linker64` (64-bit). Here are source links to different versions of the linker:

- [Android 5.0 linker](https://android.googlesource.com/platform/bionic/+/lollipop-mr1-release/linker/linker.cpp)
- [Android 6.0 linker](https://android.googlesource.com/platform/bionic/+/marshmallow-mr1-release/linker/linker.cpp)
- [Android 7.0 linker](https://android.googlesource.com/platform/bionic/+/nougat-mr1-release/linker/linker.cpp)

Some notes about the linker:

- The linker warns about unused [dynamic section entries](https://docs.oracle.com/cd/E23824_01/html/819-0690/chapter6-42444.html) with a `WARNING: linker: $BINARY: unused DT entry: type ${VALUE_OF_d_tag}` message.

- The supported types of dynamic section entries has increased over time.

- The Termux build system uses [termux-elf-cleaner](https://github.com/termux/termux-elf-cleaner) to strip away unused ELF entries causing the above mentioned linker warnings.

- Symbol versioning is supported only as of Android 6.0, so is stripped away.

- `DT_RPATH`, the list of directories where the linker should look for shared libraries, is not supported, so is stripped away.

- `DT_RUNPATH`, the same as above but looked at after `LD_LIBRARY_PATH`, is supported only from Android 7.0, so is stripped away.

- Symbol visibility when opening shared libraries using `dlopen()` works differently. On a normal linker, when an executable linking against a shared library libA dlopen():s another shared library libB, the symbols of libA are exposed to libB without libB needing to link against libA explicitly. This does not work with the Android linker, which can break plug-in systems where the main executable dlopen():s a plug-in which doesn't explicitly link against some shared libraries already linked to by the executable. See [the relevant NDK issue](https://github.com/android-ndk/ndk/issues/201) for more information.
