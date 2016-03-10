Termux packages
===============
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to cross compile and package packages for
the [Termux](http://termux.com/) Android application.

The scripts and patches to build each package is licensed under the same license as
the actual package (so the patches and scripts to build bash are licensed under
the same license as bash, while the patches and scripts to build python are licensed
under the same license as python, etc).

NOTE: This is in a rough state - be prepared for some work and frustrations, and give
feedback if you find incorrect our outdated things!

Initial setup
=============
Building packages are for now only tested to work on Ubuntu 15.10. Perform the following
setup steps:

* Run `ubuntu-setup.sh` to install required packages and setup the `/data/` folder (see below).

* Install the Android SDK at `$HOME/lib/android-sdk`. Override this by setting the environment
variable `$ANDROID_HOME` to point at another location.

* Install the Android NDK, version r11, at `$HOME/lib/android-ndk`. Override this by setting
the environment variable `$NDK` to point at another location.

Alternatively a Dockerfile is provided which sets up a pristine image
suitable for building packages. To build the docker image, run the
following command:

    docker build --rm=true -t termux .

After build is successful, you can open an interactive prompt inside the
container using:

    docker run --rm=true -ti termux /bin/bash


Building a package
==================
In a non-rooted Android device an app such as Termux may not write to system locations,
which is why every package is installed inside the private file area of the Termux app:

    PREFIX=/data/data/com.termux/files/usr

For simplicity while developing and building, the build scripts here assume that a /data
folder is reserved for use on the host builder and install everything there.

The basic flow is then to run "./build-package.sh $PKG", which:
* Sets up a patched stand-alone Android NDK toolchain

* Reads packages/$PKG/build.sh to find out where to find the source code of the  package and how to build it.

* Applies all patches in packages/$PKG/\*.patch

* Builds the package and installs it to $PREFIX

* Creates a dpkg package file for distribution.

Reading and following build-package.sh is the best way to understand what's going on here.


Additional utilities
====================
* build-all.sh: used for building all packages in the correct order (using buildorder.py)

* check-pie.sh: Used for verifying that all binaries are using PIE, which is required for Android 5+

* detect-hardlinks.sh: Used for finding if any packages uses hardlinks, which does not work on Android M

* check-versions.sh: used for checking for package updates

* clean-rebuild-all.sh: used for doing a clean rebuild of all packages (takes a couple of hours)
	
* list-packages.sh: used for listing all packages with a one-line summary


Resources about cross-compiling packages
========================================
* [Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/svn/index.html)

* [Beyond Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/svn/)

* [Cross-Compiled Linux From Scratch](http://cross-lfs.org/view/svn/x86_64-64/)

* [OpenWrt](https://openwrt.org/), an embedded Linx distribution, contains [patches and build scripts](https://dev.openwrt.org/browser/packages)

* http://dan.drown.org/android contains [patches for cross-compiling to Android](http://dan.drown.org/android/src/) as well as [work notes](http://dan.drown.org/android/worknotes.html), including a modified dynamic linker to avoid messing with LD_LIBRARY_PATH.

* [CCTools](http://cctools.info/index.php?title=Main_Page) is an Android native IDE containing [patches for several programs](https://code.google.com/p/cctools/source/browse/#svn%2Ftrunk%2Fcctools-repo%2Fpatches) and [a bug tracker](https://code.google.com/p/cctools/issues/list).

* [BotBrew](http://botbrew.com/) was a package manager for rooted devices with [sources on github](https://github.com/jyio/botbrew). Based on opkg and was transitioning to apt.

* [Kivy recipes](https://github.com/kivy/python-for-android/tree/master/recipes) contains recipes for building packages for Android.


Common porting problems
=======================
* The Android bionic libc does not have iconv and gettext/libintl functionality built in. A package from the NDK, libandroid-support,
contains these and may be used by all packages.

* "error: z: no archive symbol table (run ranlib)" usually means that the build machines libz is used instead of the one for cross compilation, due to the builder library -L path being setup incorrectly

* rindex(3) is defined in &lt;strings.h&gt; but does not exist in NDK, but strrchr(3) from &lt;string.h&gt; is preferred anyway

* &lt;sys/termios.h&gt; does not exist, but &lt;termios.h&gt; is the standard location.

* &lt;sys/fcntl.h&gt; does not exist, but &lt;fcntl.h&gt; is the standard location.

* glob(3) system function (glob.h) - not in bionic, but use the `libandroid-glob` package

* cmake and cross compiling: http://www.cmake.org/Wiki/CMake_Cross_Compiling
  CMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX to search there.
  CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY and
  CMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
  for only searching there and don't fall back to build machines

* Android is removing sys/timeb.h because it was removed in POSIX 2008, but ftime(3) can be replaced with gettimeofday(2)

* mempcpy(3) is a GNU extension. We have added it to &lt;string.h&gt; provided TERMUX_EXPOSE_MEMPCPY is defined,
  so use something like CFLAGS+=" -DTERMUX_EXPOSE_MEMPCPY=1" for packages expecting that function to exist.


dlopen() and RTLD&#95;&#42; flags
=================================
&lt;dlfcn.h&gt; declares

    enum { RTLD_NOW=0, RTLD_LAZY=1, RTLD_LOCAL=0, RTLD_GLOBAL=2,       RTLD_NOLOAD=4}; // 32-bit
    enum { RTLD_NOW=2, RTLD_LAZY=1, RTLD_LOCAL=0, RTLD_GLOBAL=0x00100, RTLD_NOLOAD=4}; // 64-bit

These differs from glibc ones in that

1. They are not preprocessor #define:s so cannot be checked for with #ifdef RTLD_GLOBAL (dln.c in ruby does this)
2. They differ in value from glibc ones, so cannot be hardcoded in files (DLFCN.py in python does this)
3. They are missing some values (RTLD_BINDING_MASK, RTLD_NOLOAD, ...)


RPATH, LD_LIBRARY_PATH AND RUNPATH
==================================
On desktop linux the linker searches for shared libraries in:

1. RPATH - a list of directories which is linked into the executable, supported on most UNIX systems. It is ignored if RUNPATH is present.
2. LD_LIBRARY_PATH - an environment variable which holds a list of directories
3. RUNPATH - same as RPATH, but searched after LD_LIBRARY_PATH, supported only on most recent UNIX systems

The Android linker (/system/bin/linker) does not support RPATH or RUNPATH, so we set LD_LIBRARY_PATH=$USR/lib and try to avoid building useless rpath entries with --disable-rpath configure flags. Another option to avoid depending on LD_LIBRARY_PATH would be supplying a custom linker - this is not done due to the overhead of maintaining a custom linker.


Warnings about unused DT entries
================================
Starting from 5.1 the Android linker warns about VERNEED (0x6FFFFFFE) and VERNEEDNUM (0x6FFFFFFF) ELF dynamic sections:

    WARNING: linker: $BINARY: unused DT entry: type 0x6ffffffe arg ...
    WARNING: linker: $BINARY: unused DT entry: type 0x6fffffff arg ...
These may come from version scripts in a Makefile such as:

    -Wl,--version-script=$(top_srcdir)/proc/libprocps.sym
The termux-elf-cleaner utilty is run from build-package.sh and should normally take care of that problem.
