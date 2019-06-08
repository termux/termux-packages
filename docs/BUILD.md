# Build Documentation

This document is intended to describe how to build a package.

## Flow of a Build

### Basics

Package build flow is controlled by script [build-package.sh](../build-package.sh)
and is split into the following stages:

1. Read `packages/$PKG/build.sh` to obtain package metadata (e.g. version,
   description, dependencies), URLs for source code and steps to build package.

2. Extract the archives with source code into `$HOME/.termux-build/$PKG/src`.
   This step is not performed when `TERMUX_PKG_SKIP_SRC_EXTRACT` is set.

3. Build package for the host. This step is performed only when
   `TERMUX_PKG_HOSTBUILD` is set.

4. Set up a standalone Android NDK toolchain and patch NDK sysroot from patches
   located in [ndk-patches](../ndk-patches) directory. This step performed only
   one time per each architecture.

5. Search for patches in `packages/$TERMUX_PKG_NAME/*.patch` and apply them.

6. Build the package under directory `$HOME/.termux-build/$PKG/build`. If
   `TERMUX_PKG_BUILD_IN_SRC` is set, then build will be done in directory `$HOME/.termux-build/$PKG/src`.

7. Install built stuff into `$TERMUX_PREFIX`.

8. Find modified files in `$TERMUX_PREFIX` and extract them into
   `$HOME/.termux-build/$PKG/massage`.

9. Perform "massage" on files in `$HOME/.termux-build/$PKG/massage`. For example,
   split files between subpackages.

10. Create a debian archive file that is ready for distribution.

### Details Table

| Order | Function Name | Overridable | Description |
| -----:|:-------------:| -----------:|:----------- |
| 0.1   | `termux_error_exit` | no | Stop script and output error. |
| 0.2   | `termux_download` | no | Utility function to download any file. |
| 0.3   | `termux_setup_golang` | no | Setup Go Build environment. |
| 0.4   | `termux_setup_rust` | no | Setup Cargo Build. |
| 0.5   | `termux_setup_ninja` | no | Setup Ninja make system. |
| 0.6   | `termux_setup_meson` | no | Setup Meson configure system. |
| 0.7   | `termux_setup_cmake` | no | Setup CMake configure system. |
| 1     | `termux_step_handle_arguments` | no | Handle command line arguments. |
| 2     | `termux_step_setup_variables` | no | Setup essential variables like directory locations and flags. |
| 3     | `termux_step_handle_buildarch` | no | Determines architecture to build for. |
| 4     | `termux_step_get_repo_files` | no | Install dependencies if `-i` option supplied. |
| 4.1   | `termux_download_deb` | no | Download packages for installation |
| 5     | `termux_step_start_build` | no | Setup directories and files required. Read `build.sh` for variables. |
| 6     | `termux_step_extract_package` | yes | Download source package. |
| 7     | `termux_step_post_extract_package` | yes | Hook to run commands before host builds. |
| 8     | `termux_step_handle_host_build` | yes | Determine whether a host build is required. |
| 8.1   | `termux_step_host_build` | yes | Conduct a host build. |
| 9     | `termux_step_setup_toolchain` | no | Setup C Toolchain from Android NDK. |
| 10    | `termux_step_patch_package` | no | Patch all `*.patch` files as specified in the package directory. |
| 11    | `termux_step_replace_guess_scripts` | no | Replace `config.sub` and `config.guess` scripts. |
| 12    | `termux_step_pre_configure` | yes | Hook to run commands before configures. |
| 13    | `termux_step_configure` | yes | Determine the configure method. |
| 13.1  | `termux_step_configure_autotools` | no | Run `configure` by GNU Autotools. |
| 13.2  | `termux_step_configure_cmake` | no | Run `cmake`. |
| 13.3  | `termux_step_configure_meson` | no | Run `meson`. |
| 14    | `termux_step_post_configure` | yes | Hook to run commands before make. |
| 15    | `termux_step_make` | yes | Make the package. |
| 16    | `termux_step_make_install` | yes | Install the package. |
| 17    | `termux_step_post_make_install` | yes | Hook before extraction. |
| 18    | `termux_step_install_license` | yes | ln or cp package LICENSE to usr/share/PKG/. |
| 19    | `termux_step_extract_into_massagedir` | no with `make_install` | Extracts installed files. |
| 20    | `termux_step_massage` | no | Remove unusable files. |
| 20.1  | `termux_create_subpackages` | no | Creates all subpackages. |
| 21    | `termux_step_post_massage` | yes | Final hook before packaging. |
| 22    | `termux_step_create_datatar` | no | Archive package files. |
| 23    | `termux_step_create_debfile` | no | Create package. |
| 23.1  | `termux_step_create_debscripts` | yes | Create additional Debian package files. |
| 24    | `termux_step_compare_debfiles` | no | Compare packages if `-i` option is specified. |
| 25    | `termux_step_finish_build` | no | Notification of finish. |

Order specifies function sequence. 0 order specifies utility functions.

Suborder specifies a function triggered by the main function. Functions with
different suborders are not executed simultaneously.

For more detailed descriptiom on each step, you can read [build-package.sh](../build-package.sh)

## Normal Build Process

Remarks: Software Developers should provide build instructions either in README
or INSTALL files. Otherwise good luck trying how to build :joy:.

Follow the instructions until you get a working build. If a build succeeds after
any step, skip the remaining steps.

1. Create a `build.sh` file using the [sample package template](sample/build.sh).

2. Create a `subpackage.sh` for each subpackage using the [sample package template](sample/subpackage.sh).

3. Run `./build-package.sh $PKG` to see what errors are found.

4. If any steps complain about an error line, first copy the file to another
   directory.

5. Edit the original file.

6. When tests succeed for the file, create a patch by
   `diff -u <original> <new> > packages/<pkg>/<filename>.patch`

7. Repeat steps 4-6 for each error file.

8. If extra configuration or make arguments are needed, specify in `build.sh`
   as shown in sample package.

9. (optional but appreciated) Test the package by yourself.

## Common Porting Problems

- Most programs expect that target is [FHS](https://uk.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
  compliant. They have hardcoded paths like `/etc`, `/bin`, `/usr/share`, `/tmp`
  which are not available in Termux at standard locations but only in `$TERMUX_PREFIX`.

- The Android bionic libc does not have iconv and gettext/libintl functionality
  built in. A `libandroid-support` package contains these and may be used by all
  packages.

- "error: z: no archive symbol table (run ranlib)" usually means that the build
  machine's libz is used instead of the one for cross-compilation due to the
  builder library -L path being setup incorrectly.

- rindex(3) does not exist, but strrchr(3) is preferred anyway.

- &lt;sys/termios.h&gt; does not exist, but &lt;termios.h&gt; is the standard
  location.

- &lt;sys/fcntl.h&gt; does not exist, but &lt;fcntl.h&gt; is the standard
  location.

- &lt;sys/timeb.h&gt; does not exist (removed in POSIX 2008), but ftime(3) can
  be replaced with gettimeofday(2).

- &lt;glob.h&gt; does not exist, but is available through the `libandroid-glob`
  package.

- SYSV shared memory is not supported by the kernel. A `libandroid-shmem`
  package, which emulates SYSV shared memory on top of the [ashmem](http://elinux.org/Android_Kernel_Features#ashmem)
  shared memory system, is available. Use it with `LDFLAGS+=" -landroid-shmem`.

- SYSV semaphores are not supported by the kernel. Use unnamed POSIX semaphores
  instead (named semaphores are unimplemented).

- Starting from Android 8, a [Seccomp](https://android-developers.googleblog.com/2017/07/seccomp-filter-in-android-o.html)
  was enabled for applications. Seccomp forbids usage of some system calls
  which results in crash with `Bad system call` errors.

- Starting from Android 8, programs cannot use `tcsetattr()` with `TCSAFLUSH`
  parameter due to SELinux. Use `TCSANOW` instead.

- Starting from Android 9, [Seccomp](https://android-developers.googleblog.com/2017/07/seccomp-filter-in-android-o.html)
  began to block `setuid()`-related system calls. Since Termux is primarily for
  single-user non-root usage, setuid/setgid functionality is discouraged anyway.

### dlopen() and RTLD&#95;&#42; flags

&lt;dlfcn.h&gt; declares
```C
RTLD_NOW=0; RTLD_LAZY=1; RTLD_LOCAL=0; RTLD_GLOBAL=2;       RTLD_NOLOAD=4; // 32-bit
RTLD_NOW=2; RTLD_LAZY=1; RTLD_LOCAL=0; RTLD_GLOBAL=0x00100; RTLD_NOLOAD=4; // 64-bit
```
These differs from glibc ones in that

1. They differ in value from glibc ones, so cannot be hardcoded in files
   (DLFCN.py in python does this)

2. They are missing some values (`RTLD_BINDING_MASK`, ...)

### Android Dynamic Linker

The Android dynamic linker is located at `/system/bin/linker` (32-bit) or
`/system/bin/linker64` (64-bit). Here are source links to different versions of the linker:

- [Android 5.0 linker](https://android.googlesource.com/platform/bionic/+/lollipop-mr1-release/linker/linker.cpp)

- [Android 6.0 linker](https://android.googlesource.com/platform/bionic/+/marshmallow-mr1-release/linker/linker.cpp)

- [Android 7.0 linker](https://android.googlesource.com/platform/bionic/+/nougat-mr1-release/linker/linker.cpp)

Some notes about the linker:

- The linker warns about unused [dynamic section entries](https://docs.oracle.com/cd/E23824_01/html/819-0690/chapter6-42444.html)
  with a `WARNING: linker: $BINARY: unused DT entry: type ${VALUE_OF_d_tag}`
  message.

- The supported types of dynamic section entries have increased over time.

- The Termux build system uses [termux-elf-cleaner](https://github.com/termux/termux-elf-cleaner)
  to strip away unused ELF entries causing the above mentioned linker warnings.

- Symbol versioning is supported only as of Android 6.0, so is stripped away.

- `DT_RPATH`, the list of directories where the linker should look for shared
  libraries is not supported, so is stripped away.

- `DT_RUNPATH`, the same as above but looked at after `LD_LIBRARY_PATH`, is
  supported only from Android 7.0, so is stripped away.

- Symbol visibility when opening shared libraries using `dlopen()` works
  differently. On a normal linker, when an executable linking against a shared
  library libA dlopen():s another shared library libB, the symbols of libA are
  exposed to libB without libB needing to link against libA explicitly. This
  does not work with the Android linker, which can break plug-in systems where
  the main executable dlopen():s a plug-in which doesn't explicitly link against
  some shared libraries already linked to by the executable.
  See [the relevant NDK issue](https://github.com/android-ndk/ndk/issues/201)
  for more information.
