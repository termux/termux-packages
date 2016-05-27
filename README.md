Termux packages
===============
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to cross compile and package packages for
the [Termux](https://termux.com/) Android application.

The scripts and patches to build each package is licensed under the same license as
the actual package (so the patches and scripts to build bash are licensed under
the same license as bash, while the patches and scripts to build python are licensed
under the same license as python, etc).

NOTE: This is in a rough state - be prepared for some work and frustrations, and give
feedback if you find incorrect our outdated things!


Build environment on Ubuntu 16.04
=================================
Packages are normally built using Ubuntu 16.04. Most packages should build also under
other Linux distributions (or even on OS X), but those environments will need manual setup
adapted from the below setup for Ubuntu:

* Run `scripts/setup-ubuntu.sh` to install required packages and setup the `/data/` folder.

* Run `scripts/setup-android-sdk.sh` to install the Android SDK and NDK at `$HOME/lib/android-{sdk,ndk}`.


Build environment using Docker
==============================
A Docker container configured for building images can be downloaded an run with:

    ./scripts/run-docker.sh

This will set you up with a interactive prompt in a container, where this source folder
is mounted as the /root/termux-packages data volume, so changes are kept in sync between
the host and the container when trying things out before committing.

The build output folder is mounted to $HOME/termux, so deb files can be found in
$HOME/termux/_deb on the host for trying them out on a device or emulator.


Building a package
==================
The basic build operation is to run `./build-package.sh $PKG`, which:

* Sets up a patched stand-alone Android NDK toolchain if necessary.

* Reads `packages/$PKG/build.s`h to find out where to find the source code of the  package and how to build it.

* Applies all patches in packages/$PKG/\*.patch.

* Builds the package and installs it to `$PREFIX`.

* Creates a dpkg package file for distribution in `$HOME/termux/_deb`.

Reading `build-package.sh` is the best way to understand what is going on.


Additional utilities
====================
* build-all.sh: used for building all packages in the correct order (using buildorder.py).

* clean-rebuild-all.sh: used for doing a clean rebuild of all packages.

* scripts/check-pie.sh: Used for verifying that all binaries are using PIE, which is required for Android 5+.

* scripts/detect-hardlinks.sh: Used for finding if any packages uses hardlinks, which does not work on Android M.

* scripts/check-versions.sh: used for checking for package updates.
	
* scripts/list-packages.sh: used for listing all packages with a one-line summary.


Resources about cross-compiling packages
========================================
* [Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/svn/index.html)

* [Beyond Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/stable/)

* [Cross-Compiled Linux From Scratch](http://www.clfs.org/view/CLFS-3.0.0-SYSVINIT/mips64-64/)

* [OpenWrt](https://openwrt.org/) as an embedded Linx distribution contains [patches and build scripts](https://dev.openwrt.org/browser/packages)

* http://dan.drown.org/android contains [patches for cross-compiling to Android](http://dan.drown.org/android/src/) as well as [work notes](http://dan.drown.org/android/worknotes.html), including a modified dynamic linker to avoid messing with `LD_LIBRARY_PATH`.

* [Kivy recipes](https://github.com/kivy/python-for-android/tree/master/pythonforandroid/recipes) contains recipes for building packages for Android.


Common porting problems
=======================
* The Android bionic libc does not have iconv and gettext/libintl functionality built in. A package from the NDK, libandroid-support,
contains these and may be used by all packages.

* "error: z: no archive symbol table (run ranlib)" usually means that the build machines libz is used instead of the one for cross compilation, due to the builder library -L path being setup incorrectly

* rindex(3) is defined in &lt;strings.h&gt; but does not exist in NDK, but strrchr(3) from &lt;string.h&gt; is preferred anyway

* &lt;sys/termios.h&gt; does not exist, but &lt;termios.h&gt; is the standard location.

* &lt;sys/fcntl.h&gt; does not exist, but &lt;fcntl.h&gt; is the standard location.

* glob(3) system function (glob.h) - not in bionic, but use the `libandroid-glob` package

* [Cmake and cross compiling](http://www.cmake.org/Wiki/CMake_Cross_Compiling).
  `CMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX` to search there.
  `CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY` and `CMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY`
  for only searching there and don't fall back to build machines

* Android is removing sys/timeb.h because it was removed in POSIX 2008, but ftime(3) can be replaced with gettimeofday(2)

* mempcpy(3) is a GNU extension. We have added it to &lt;string.h&gt; provided TERMUX_EXPOSE_MEMPCPY is defined,
  so use something like CFLAGS+=" -DTERMUX_EXPOSE_MEMPCPY=1" for packages expecting that function to exist.


dlopen() and RTLD&#95;&#42; flags
=================================
&lt;dlfcn.h&gt; originally declares

    enum { RTLD_NOW=0, RTLD_LAZY=1, RTLD_LOCAL=0, RTLD_GLOBAL=2,       RTLD_NOLOAD=4}; // 32-bit
    enum { RTLD_NOW=2, RTLD_LAZY=1, RTLD_LOCAL=0, RTLD_GLOBAL=0x00100, RTLD_NOLOAD=4}; // 64-bit

These differs from glibc ones in that

1. They are not preprocessor #define:s so cannot be checked for with `#ifdef RTLD_GLOBAL`. Termux patches this to #define values for compatibility with several packages.
2. They differ in value from glibc ones, so cannot be hardcoded in files (DLFCN.py in python does this)
3. They are missing some values (`RTLD_BINDING_MASK`, `RTLD_NOLOAD`, ...)


RPATH, RUNPATH AND LD\_LIBRARY\_PATH
====================================
On desktop linux the linker searches for shared libraries in:

1. `RPATH` - a list of directories which is linked into the executable, supported on most UNIX systems. It is ignored if `RUNPATH` is present.
2. `LD_LIBRARY_PATH` - an environment variable which holds a list of directories
3. `RUNPATH` - same as `RPATH`, but searched after `LD_LIBRARY_PATH`, supported only on most recent UNIX systems

The Android linker (/system/bin/linker) does not support `RPATH` or `RUNPATH`, so we set `LD_LIBRARY_PATH=$PREFIX/lib` and try to avoid building useless rpath entries with --disable-rpath configure flags. Another option to avoid depending on `LD_LIBRARY_PATH` would be supplying a custom linker - this is not done due to the overhead of maintaining a custom linker.


Warnings about unused DT entries
================================
Starting from 5.1 the Android linker warns about VERNEED (0x6FFFFFFE) and VERNEEDNUM (0x6FFFFFFF) ELF dynamic sections:

    WARNING: linker: $BINARY: unused DT entry: type 0x6ffffffe arg ...
    WARNING: linker: $BINARY: unused DT entry: type 0x6fffffff arg ...

These may come from version scripts in a Makefile such as:

    -Wl,--version-script=$(top_srcdir)/proc/libprocps.sym

The termux-elf-cleaner utilty is run from build-package.sh and should normally take care of that problem.
