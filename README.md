Termux packages
===============
[![Join the chat at https://gitter.im/termux/termux](https://badges.gitter.im/termux/termux.svg)](https://gitter.im/termux/termux)

This project contains scripts and patches to build packages for the
[Termux](https://termux.com/) Android application.

License
=======
The scripts and patches to build each package is licensed under the same license as
the actual package (so the patches and scripts to build bash are licensed under
the same license as bash, while the patches and scripts to build python are licensed
under the same license as python).

Build environment on Ubuntu 16.10
=================================
Packages are built using Ubuntu 16.10. Perform the following steps to configure a Ubuntu 16.10 installation:

- Run `scripts/setup-ubuntu.sh` to install required packages and setup the `/data/` folder.

- Run `scripts/setup-android-sdk.sh` to install the Android SDK and NDK at `$HOME/lib/android-{sdk,ndk}`.

There is also a [Vagrantfile](scripts/Vagrantfile) available for setting up an Ubuntu environment using a virtual machine on other operating systems.

Build environment using Docker
==============================
On other Linux distributions than Ubuntu 16.10 (or on other platforms than Linux) the best course
of action is to setup a Docker container for building packages by executing:

    ./scripts/run-docker.sh     # On Linux and macOS.
     .\scripts\run-docker.ps1   # On Windows.

This will setup a container (from an image created by [scripts/Dockerfile](scripts/Dockerfile))
suitable for building packages.

This source folder is mounted as the /root/termux-packages data volume, so changes are kept
in sync between the host and the container when trying things out before committing, and built
deb files will be available on the host in the `debs/` directory just as when building on the host.

Build commands can be given to be executed in the docker container directly:

    ./scripts/run-docker.sh ./build-package.sh libandroid-support

will launch the docker container, execute the `./build-package.sh libandroid-support`
command inside it and afterwards return you to the host prompt, with the newly built
deb in `debs/` to try out.

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

* scripts/detect-hardlinks.sh: Used for finding if any packages uses hardlinks, which does not work on Android M.

* scripts/check-versions.sh: used for checking for package updates.
	
* scripts/list-packages.sh: used for listing all packages with a one-line summary.


Resources
=========
* [Android changes for NDK developers](https://android.googlesource.com/platform/bionic/+/master/android-changes-for-ndk-developers.md)

* [Linux From Scratch](http://www.linuxfromscratch.org/lfs/view/stable/)

* [Beyond Linux From Scratch](http://www.linuxfromscratch.org/blfs/view/stable/)

* [Cross-Compiled Linux From Scratch](http://www.clfs.org/view/CLFS-3.0.0-SYSVINIT/mips64-64/)

* [OpenWrt](https://openwrt.org/) as an embedded Linx distribution contains [patches and build scripts](https://dev.openwrt.org/browser/packages)

* http://dan.drown.org/android contains [patches for cross-compiling to Android](http://dan.drown.org/android/src/) as well as [work notes](http://dan.drown.org/android/worknotes.html), including a modified dynamic linker to avoid messing with `LD_LIBRARY_PATH`.

* [Kivy recipes](https://github.com/kivy/python-for-android/tree/master/pythonforandroid/recipes) contains recipes for building packages for Android.


Common porting problems
=======================
* The Android bionic libc does not have iconv and gettext/libintl functionality built in. A package from the NDK, libandroid-support, contains these and may be used by all packages.

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

* Android uses a customized version of shared memory managemnt known as ashmem. libandroid-shmem wraps SYSV shared
  memory calls to standard ashmem operations. Use it with `LDFLAGS+=" -landroid-shmem`.

* SYSV semaphores (semget(2), semop(2) and others) aren't available.
  Use unnamed POSIX semaphores instead (named semaphores are unimplemented).

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

The Android linker, /system/bin/linker, does not support RPATH or RUNPATH, so we set `LD_LIBRARY_PATH=$PREFIX/lib` and try to avoid building useless rpath entries (which the linker warns about) with --disable-rpath configure flags. NOTE: Starting from Android 7.0 RUNPATH (but not RPATH) is supported.

Warnings about unused DT entries
================================
Starting from 5.1 the Android linker warns about VERNEED (0x6FFFFFFE) and VERNEEDNUM (0x6FFFFFFF) ELF dynamic sections (WARNING: linker: $BINARY: unused DT entry: type 0x6ffffffe/0x6fffffff). These may come from version scripts (`-Wl,--version-script=`). The termux-elf-cleaner utilty is run from build-package.sh and should normally take care of that problem. NOTE: Starting from Android 6.0 symbol versioning is supported.
