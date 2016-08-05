#!/bin/bash

set -e -o pipefail -u

# Read settings from .termuxrc if existing:
test -f $HOME/.termuxrc && . $HOME/.termuxrc

# Configurable settings:
: ${ANDROID_HOME:="${HOME}/lib/android-sdk"}
: ${NDK:="${HOME}/lib/android-ndk"}
: ${TERMUX_MAKE_PROCESSES:='4'}
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}
: ${TERMUX_ARCH:="aarch64"} # (arm|aarch64|i686|x86_64) - the x86_64 arch is not yet used or tested.
: ${TERMUX_CLANG:=""} # Set to non-empty to use clang.
: ${TERMUX_PREFIX:='/data/data/com.termux/files/usr'}
: ${TERMUX_ANDROID_HOME:='/data/data/com.termux/files/home'}
: ${TERMUX_DEBUG:=""}
: ${TERMUX_PROCESS_DEB:=""}
: ${TERMUX_API_LEVEL:="21"}
: ${TERMUX_ANDROID_BUILD_TOOLS_VERSION:="24.0.1"}
: ${TERMUX_NDK_VERSION:="12"}

# Handle command-line arguments:
show_usage () {
    echo "Usage: ./build-package.sh [-a ARCH] PACKAGE"
    echo "Build a package."
    echo ""
    exit 1
}
while getopts :a:h option
do
    case "$option" in
        a) TERMUX_ARCH="$OPTARG";;
        h) show_usage;;
        ?) echo "./build-package.sh: illegal option -$OPTARG"; exit 1;;
    esac
done
shift $(($OPTIND-1))
if [ "$#" -ne 1 ]; then show_usage; fi

# Check the NDK:
if [ ! -d "$NDK" ]; then
	echo 'ERROR: $NDK not defined as pointing at a directory - define it pointing at a android NDK installation!'
	exit 1
fi
if grep -s -q "Pkg.Revision = $TERMUX_NDK_VERSION" $NDK/source.properties; then
	:
else
	echo "Wrong NDK version - we need $TERMUX_NDK_VERSION"
	exit 1
fi

# Compute standalone toolchain dir, bitness of arch and name of host platform:
TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_TOPDIR/_lib/android-standalone-toolchain-${TERMUX_ARCH}-ndk${TERMUX_NDK_VERSION}-api${TERMUX_API_LEVEL}-"
if [ "$TERMUX_CLANG" = "" ]; then
	TERMUX_STANDALONE_TOOLCHAIN+="gcc4.9"
else
	TERMUX_STANDALONE_TOOLCHAIN+="clang38"
fi
if [ "x86_64" = $TERMUX_ARCH -o "aarch64" = $TERMUX_ARCH ]; then
	TERMUX_ARCH_BITS=64
else
	TERMUX_ARCH_BITS=32
fi
TERMUX_HOST_PLATFORM="${TERMUX_ARCH}-linux-android"
if [ $TERMUX_ARCH = "arm" ]; then TERMUX_HOST_PLATFORM="${TERMUX_HOST_PLATFORM}eabi"; fi

# Check the package to build:
TERMUX_PKG_NAME=`basename $1`
export TERMUX_SCRIPTDIR=`cd $(dirname $0); pwd`
if [[ $1 == *"/"* ]]; then
  # Path to directory which may be outside this repo:
  if [ ! -d $1 ]; then echo "ERROR: '$1' seems to be a path but is not a directory"; exit 1; fi
  export TERMUX_PKG_BUILDER_DIR=`realpath $1`
else
  # Package name:
  export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/packages/$TERMUX_PKG_NAME
fi
TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh
if test ! -f $TERMUX_PKG_BUILDER_SCRIPT; then
	echo "ERROR: No build.sh script at supposed package dir $TERMUX_PKG_BUILDER_DIR!"
	exit 1
fi

# Handle 'all' arch:
if [ $TERMUX_ARCH = 'all' ]; then
	for arch in 'arm' 'i686' 'aarch64'; do
		./build-package.sh -a $arch $1
	done
	exit
fi

# We do not put all of build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/ into PATH
# to avoid stuff like arm-linux-androideabi-ld there to conflict with ones from
# the standalone toolchain.
TERMUX_DX=$ANDROID_HOME/build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/dx
TERMUX_JACK=$ANDROID_HOME/build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/jack.jar
TERMUX_JILL=$ANDROID_HOME/build-tools/$TERMUX_ANDROID_BUILD_TOOLS_VERSION/jill.jar

# We put this after system PATH to avoid picking up toolchain stripped python
export PATH=$PATH:$TERMUX_STANDALONE_TOOLCHAIN/bin

# Make $TERMUX_TAR and $TERMUX_TOUCH point at gnu versions:
export TERMUX_TAR="tar"
test `uname` = "Darwin" && TERMUX_TAR=gtar
export TERMUX_TOUCH="touch"
test `uname` = "Darwin" && TERMUX_TOUCH=gtouch

export prefix=${TERMUX_PREFIX} # prefix is used by some makefiles
#export ACLOCAL="aclocal -I $TERMUX_PREFIX/share/aclocal"
export AR=$TERMUX_HOST_PLATFORM-ar
if [ "$TERMUX_CLANG" = "" ]; then
	export AS=${TERMUX_HOST_PLATFORM}-gcc
	export CC=$TERMUX_HOST_PLATFORM-gcc
	export CXX=$TERMUX_HOST_PLATFORM-g++
	_SPECSFLAG="-specs=$TERMUX_SCRIPTDIR/termux.spec"
else
	export AS=${TERMUX_HOST_PLATFORM}-gcc
	export CC=$TERMUX_HOST_PLATFORM-clang
	export CXX=$TERMUX_HOST_PLATFORM-clang++
	# TODO: clang does not have specs file, how to ensure pie
	# binaries gets built?
	_SPECSFLAG=""
fi
export CPP=${TERMUX_HOST_PLATFORM}-cpp
export CC_FOR_BUILD=gcc
export LD=$TERMUX_HOST_PLATFORM-ld
export OBJDUMP=$TERMUX_HOST_PLATFORM-objdump
# Setup pkg-config for cross-compiling:
export PKG_CONFIG=$TERMUX_STANDALONE_TOOLCHAIN/bin/${TERMUX_HOST_PLATFORM}-pkg-config
export PKG_CONFIG_LIBDIR=$TERMUX_PREFIX/lib/pkgconfig
export RANLIB=$TERMUX_HOST_PLATFORM-ranlib
export READELF=$TERMUX_HOST_PLATFORM-readelf
export STRIP=$TERMUX_HOST_PLATFORM-strip

export CFLAGS="$_SPECSFLAG"
export LDFLAGS="$_SPECSFLAG -L${TERMUX_PREFIX}/lib"

if [ "$TERMUX_ARCH" = "arm" ]; then
	CFLAGS+=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp"
	# "first flag instructs the linker to pick libgcc.a, libgcov.a, and
	# crt*.o, which are tailored for armv7-a"
	# - https://developer.android.com/ndk/guides/standalone_toolchain.html
	LDFLAGS+=" -march=armv7-a -Wl,--fix-cortex-a8"
elif [ $TERMUX_ARCH = "i686" ]; then
	# From $NDK/docs/CPU-ARCH-ABIS.html:
	CFLAGS+=" -march=i686 -msse3 -mstackrealign -mfpmath=sse"
elif [ $TERMUX_ARCH = "aarch64" ]; then
	LDFLAGS+=" -Wl,-rpath-link,$TERMUX_PREFIX/lib"
	LDFLAGS+=" -Wl,-rpath-link,$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
elif [ $TERMUX_ARCH = "x86_64" ]; then
	:
else
	echo "Error: Invalid arch '$TERMUX_ARCH' - support arches are 'arm', 'i686', 'aarch64', 'x86_64'"
	exit 1
fi

if [ -n "$TERMUX_DEBUG" ]; then
        CFLAGS+=" -g3 -Og -fstack-protector --param ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
else
        CFLAGS+=" -Os"
fi

export CXXFLAGS="$CFLAGS"
export CPPFLAGS="-I${TERMUX_PREFIX}/include"

export ac_cv_func_getpwent=no
export ac_cv_func_getpwnam=no
export ac_cv_func_getpwuid=no

if [ ! -d $TERMUX_STANDALONE_TOOLCHAIN ]; then
	# See https://developer.android.com/ndk/guides/standalone_toolchain.html about toolchain naming.
	if [ "i686" = $TERMUX_ARCH ]; then
		_TERMUX_NDK_TOOLCHAIN_NAME="x86"
	elif [ "x86_64" = $TERMUX_ARCH ]; then
		_TERMUX_NDK_TOOLCHAIN_NAME="x86_64"
	else
		_TERMUX_NDK_TOOLCHAIN_NAME="$TERMUX_HOST_PLATFORM"
	fi

	if [ "$TERMUX_CLANG" = "" ]; then
		_TERMUX_TOOLCHAIN="${_TERMUX_NDK_TOOLCHAIN_NAME}-4.9"
	else
		_TERMUX_TOOLCHAIN="${_TERMUX_NDK_TOOLCHAIN_NAME}-clang"
	fi

	# Do not put toolchain in place until we are done with setup, to avoid having a half setup
	# toolchain left in place if something goes wrong (or process is just aborted):
	_TERMUX_TOOLCHAIN_TMPDIR=${TERMUX_STANDALONE_TOOLCHAIN}-tmp
	rm -Rf $_TERMUX_TOOLCHAIN_TMPDIR

	bash $NDK/build/tools/make-standalone-toolchain.sh --platform=android-$TERMUX_API_LEVEL --toolchain=${_TERMUX_TOOLCHAIN} \
		--install-dir=$_TERMUX_TOOLCHAIN_TMPDIR
        if [ "arm" = $TERMUX_ARCH ]; then
                # Fix to allow e.g. <bits/c++config.h> to be included:
                cp $_TERMUX_TOOLCHAIN_TMPDIR/include/c++/4.9.x/arm-linux-androideabi/armv7-a/bits/* $_TERMUX_TOOLCHAIN_TMPDIR/include/c++/4.9.x/bits
        fi
	cd $_TERMUX_TOOLCHAIN_TMPDIR/sysroot
	for f in $TERMUX_SCRIPTDIR/ndk_patches/*.patch; do
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $f | \
			sed "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" | \
			patch --silent -p1;
	done
        # elf.h is taken from glibc since the elf.h in the NDK is lacking.
	# sysexits.h is header-only and used by a few programs.
	cp $TERMUX_SCRIPTDIR/ndk_patches/{elf.h,sysexits.h} $_TERMUX_TOOLCHAIN_TMPDIR/sysroot/usr/include
	mv $_TERMUX_TOOLCHAIN_TMPDIR $TERMUX_STANDALONE_TOOLCHAIN
fi

export TERMUX_COMMON_CACHEDIR="$TERMUX_TOPDIR/_cache"
export TERMUX_DEBDIR="$TERMUX_SCRIPTDIR/debs"
mkdir -p $TERMUX_COMMON_CACHEDIR $TERMUX_DEBDIR

TERMUX_PKG_BUILDDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/build
TERMUX_PKG_CACHEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/cache
TERMUX_PKG_MASSAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/massage
TERMUX_PKG_PACKAGEDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/package
TERMUX_PKG_SRCDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/src
TERMUX_PKG_TMPDIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/tmp
TERMUX_PKG_HOSTBUILD_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/host-build
TERMUX_PKG_PLATFORM_INDEPENDENT=""
TERMUX_PKG_NO_DEVELSPLIT=""
TERMUX_PKG_BUILD_REVISION="0" # http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS=""
TERMUX_PKG_EXTRA_MAKE_ARGS=""
TERMUX_PKG_BUILD_IN_SRC=""
TERMUX_PKG_RM_AFTER_INSTALL=""
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_HOMEPAGE=""
TERMUX_PKG_DESCRIPTION="FIXME:Add description"
TERMUX_PKG_FOLDERNAME=""
TERMUX_PKG_KEEP_STATIC_LIBRARIES="false"
TERMUX_PKG_KEEP_HEADER_FILES="false"
TERMUX_PKG_ESSENTIAL=""
TERMUX_PKG_CONFLICTS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-conflicts
TERMUX_PKG_CONFFILES=""
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE=""
TERMUX_PKG_DEVPACKAGE_DEPENDS=""
# Set if a host build should be done in TERMUX_PKG_HOSTBUILD_DIR:
TERMUX_PKG_HOSTBUILD=""
TERMUX_PKG_MAINTAINER="Fredrik Fornwall <fredrik@fornwall.net>"

# Cleanup old state
rm -Rf $TERMUX_PKG_BUILDDIR $TERMUX_PKG_PACKAGEDIR $TERMUX_PKG_SRCDIR $TERMUX_PKG_TMPDIR $TERMUX_PKG_MASSAGEDIR

# If $TERMUX_PREFIX already exists, it may have been built for a different arch
TERMUX_ARCH_FILE=/data/TERMUX_ARCH
if [ -f "${TERMUX_ARCH_FILE}" ]; then
        TERMUX_PREVIOUS_ARCH=`cat $TERMUX_ARCH_FILE`
        if [ $TERMUX_PREVIOUS_ARCH != $TERMUX_ARCH ]; then
                TERMUX_DATA_BACKUPDIRS=$TERMUX_TOPDIR/_databackups
                mkdir -p $TERMUX_DATA_BACKUPDIRS
                TERMUX_DATA_PREVIOUS_BACKUPDIR=$TERMUX_DATA_BACKUPDIRS/$TERMUX_PREVIOUS_ARCH
                TERMUX_DATA_CURRENT_BACKUPDIR=$TERMUX_DATA_BACKUPDIRS/$TERMUX_ARCH
                # Save current /data (removing old backup if any)
		if test -e $TERMUX_DATA_PREVIOUS_BACKUPDIR; then
			echo "ERROR: Directory already exists"
			exit 1
		fi
                mv /data/data $TERMUX_DATA_PREVIOUS_BACKUPDIR
                # Restore new one (if any)
                if [ -d $TERMUX_DATA_CURRENT_BACKUPDIR ]; then
                        mv $TERMUX_DATA_CURRENT_BACKUPDIR /data/data
                fi
        fi
fi
echo $TERMUX_ARCH > $TERMUX_ARCH_FILE

# Ensure folders present (but not $TERMUX_PKG_SRCDIR, it will be created in build)
mkdir -p $TERMUX_PKG_BUILDDIR $TERMUX_PKG_PACKAGEDIR $TERMUX_PKG_TMPDIR $TERMUX_PKG_CACHEDIR $TERMUX_PKG_MASSAGEDIR $PKG_CONFIG_LIBDIR $TERMUX_PREFIX/{bin,etc,lib,libexec,share,tmp,include}

termux_download() {
        URL="$1"
        DESTINATION="$2"

        TMPFILE=`mktemp $TERMUX_PKG_TMPDIR/download.XXXXXXXXX`
        for i in 1 2 3 4 5 6; do
                if curl -L --fail --retry 2 -o "$TMPFILE" "$URL"; then
                        mv "$TMPFILE" "$DESTINATION"
                        return
                else
                        echo "Download of $1 failed (attempt $i/3)" 1>&2
                        sleep 45
                fi
        done
        echo "Failed to download $1 - exiting" 1>&2
        exit 1
}

# Get fresh versions of config.sub and config.guess
for f in config.sub config.guess; do
	if [ ! -f $TERMUX_COMMON_CACHEDIR/$f ]; then
		termux_download "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=${f};hb=HEAD" $TERMUX_COMMON_CACHEDIR/$f
	fi
done

# Have a debian-binary file ready for deb packaging:
test ! -f $TERMUX_COMMON_CACHEDIR/debian-binary && echo "2.0" > $TERMUX_COMMON_CACHEDIR/debian-binary
# The host tuple that may be given to --host configure flag, but normally autodetected so not needed explicitly
TERMUX_HOST_TUPLE=`sh $TERMUX_COMMON_CACHEDIR/config.guess`

# Make $TERMUX_PREFIX/bin/sh executable on the builder, so that build script can assume that it works
# on both builder and host later on:
ln -f -s /bin/sh $TERMUX_PREFIX/bin/sh

if [ ! -f $PKG_CONFIG ]; then
	echo "Creating pkg-config wrapper..."
	# We use path to host pkg-config to avoid picking up a cross-compiled pkg-config later on
	_HOST_PKGCONFIG=`which pkg-config`
	mkdir -p $TERMUX_STANDALONE_TOOLCHAIN/bin $PKG_CONFIG_LIBDIR
	cat > $PKG_CONFIG <<HERE
#!/bin/sh
export PKG_CONFIG_DIR=
export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
# export PKG_CONFIG_SYSROOT_DIR=${TERMUX_PREFIX}
exec $_HOST_PKGCONFIG "\$@"
HERE
	chmod +x $PKG_CONFIG

	# Add a pkg-config file for the system zlib
	cat > $PKG_CONFIG_LIBDIR/zlib.pc <<HERE
Name: zlib
Description: zlib compression library
Version: 1.2.3

Requires:
Libs: -L$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib -lz
Cflags: -I$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include
HERE
fi

TERMUX_ELF_CLEANER=$TERMUX_COMMON_CACHEDIR/termux-elf-cleaner
TERMUX_ELF_CLEANER_SRC=$TERMUX_SCRIPTDIR/packages/termux-elf-cleaner/termux-elf-cleaner.cpp
if [ $TERMUX_ELF_CLEANER_SRC -nt $TERMUX_ELF_CLEANER ]; then
	g++ -std=c++11 -Wall -Wextra -pedantic -Os $TERMUX_ELF_CLEANER_SRC -o $TERMUX_ELF_CLEANER
fi

# Keep track of when build started so we can see what files have been created
export TERMUX_BUILD_TS_FILE=$TERMUX_PKG_TMPDIR/timestamp_$TERMUX_PKG_NAME
sleep 1 # Sleep so that any generated files above (such as zlib.c and $PREFIX/bin/sh)
	#get older timestamp then TERMUX_BUILD_TS_FILE
rm -f $TERMUX_BUILD_TS_FILE && touch $TERMUX_BUILD_TS_FILE

# Run just after sourcing $TERMUX_PKG_BUILDER_SCRIPT
termux_step_extract_package () {
        if [ -z "${TERMUX_PKG_SRCURL:=""}" ]; then
                mkdir -p $TERMUX_PKG_SRCDIR
                return
        fi
	cd $TERMUX_PKG_TMPDIR
	filename=`basename $TERMUX_PKG_SRCURL`
	file=$TERMUX_PKG_CACHEDIR/$filename
	test ! -f $file && termux_download $TERMUX_PKG_SRCURL $file
	if [ "x$TERMUX_PKG_FOLDERNAME" = "x" ]; then
		folder=`basename $filename .tar.bz2` && folder=`basename $folder .tar.gz` && folder=`basename $folder .tar.xz` && folder=`basename $folder .tar.lz` && folder=`basename $folder .tgz` && folder=`basename $folder .zip`
		folder=`echo $folder | sed 's/_/-/'` # dpkg uses _ in tar filename, but - in folder
	else
		folder=$TERMUX_PKG_FOLDERNAME
	fi
	rm -Rf $folder
	if [ ${file##*.} = zip ]; then
		unzip -q $file
	else
		$TERMUX_TAR xf $file
	fi
	mv $folder $TERMUX_PKG_SRCDIR
}

termux_step_post_extract_package () {
        return
}

# Perform a host build. Will be called in $TERMUX_PKG_HOSTBUILD_DIR.
# After termux_step_post_extract_package() and before termux_step_patch_package()
termux_step_host_build () {
	$TERMUX_PKG_SRCDIR/configure ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make
}

# This should not be overridden
termux_step_patch_package () {
	cd $TERMUX_PKG_SRCDIR
	# Suffix patch with ".patch32" or ".patch64" to only apply for these bitnesses:
	for patch in $TERMUX_PKG_BUILDER_DIR/*.patch{$TERMUX_ARCH_BITS,}; do
		test -f $patch && sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $patch | \
			sed "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" | \
			patch --silent -p1
	done

	find . -name config.sub -exec chmod u+w '{}' \; -exec cp $TERMUX_COMMON_CACHEDIR/config.sub '{}' \;
	find . -name config.guess -exec chmod u+w '{}' \; -exec cp $TERMUX_COMMON_CACHEDIR/config.guess '{}' \;
}

termux_step_pre_configure () {
        return
}

termux_step_configure () {
        if [ ! -e $TERMUX_PKG_SRCDIR/configure ]; then
                return
        fi

	DISABLE_STATIC="--disable-static"
	if [ "$TERMUX_PKG_EXTRA_CONFIGURE_ARGS" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--enable-static/}" ]; then
		# Do not --disable-static if package explicitly enables it (e.g. gdb needs enable-static to build)
		DISABLE_STATIC=""
	fi

	DISABLE_NLS="--disable-nls"
	if [ "$TERMUX_PKG_EXTRA_CONFIGURE_ARGS" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--enable-nls/}" ]; then
		# Do not --disable-nls if package explicitly enables it (for gettext itself)
		DISABLE_NLS=""
	fi

	ENABLE_SHARED="--enable-shared"
	if [ "$TERMUX_PKG_EXTRA_CONFIGURE_ARGS" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-shared/}" ]; then
		ENABLE_SHARED=""
	fi
	HOST_FLAG="--host=$TERMUX_HOST_PLATFORM"
	if [ "$TERMUX_PKG_EXTRA_CONFIGURE_ARGS" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--host=/}" ]; then
		HOST_FLAG=""
	fi

	# Some packages provides a $PKG-config script which some configure scripts pickup instead of pkg-config:
	mkdir $TERMUX_PKG_TMPDIR/config-scripts
	for f in $TERMUX_PREFIX/bin/*config; do
		test -f $f && cp $f $TERMUX_PKG_TMPDIR/config-scripts
	done
	export PATH=$TERMUX_PKG_TMPDIR/config-scripts:$PATH

	# See http://wiki.buici.com/xwiki/bin/view/Programing+C+and+C%2B%2B/Autoconf+and+RPL_MALLOC
	# about this problem which may cause linker errors in test scripts not undef:ing malloc and
	# also cause problems with e.g. malloc interceptors such as libgc:
	local AVOID_AUTOCONF_WRAPPERS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
	# Similarly, disable gnulib's rpl_getcwd(). It returns the wrong value, affecting zile. See
	# <https://github.com/termux/termux-packages/issues/76>.
	AVOID_AUTOCONF_WRAPPERS+=" gl_cv_func_getcwd_null=yes gl_cv_func_getcwd_posix_signature=yes gl_cv_func_getcwd_path_max=yes gl_cv_func_getcwd_abort_bug=no"
	AVOID_AUTOCONF_WRAPPERS+=" gl_cv_header_working_fcntl_h=yes gl_cv_func_fcntl_f_dupfd_cloexec=yes gl_cv_func_fcntl_f_dupfd_works=yes"
	# Remove rpl_gettimeofday reference when building at least coreutils:
	AVOID_AUTOCONF_WRAPPERS+=" gl_cv_func_tzset_clobber=no gl_cv_func_gettimeofday_clobber=no gl_cv_func_gettimeofday_posix_signature=yes"

	env $AVOID_AUTOCONF_WRAPPERS $TERMUX_PKG_SRCDIR/configure \
		--disable-dependency-tracking \
		--prefix=$TERMUX_PREFIX \
                --disable-rpath --disable-rpath-hack \
		$HOST_FLAG \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS \
		$DISABLE_NLS \
		$ENABLE_SHARED \
		$DISABLE_STATIC \
		--libexecdir=$TERMUX_PREFIX/libexec
}

termux_step_post_configure () {
        return
}

termux_step_pre_make () {
        return
}

termux_step_make () {
        if ls *akefile &> /dev/null; then
                if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
                        make -j $TERMUX_MAKE_PROCESSES
                else
                        make -j $TERMUX_MAKE_PROCESSES ${TERMUX_PKG_EXTRA_MAKE_ARGS}
                fi
        fi
}

termux_step_make_install () {
        if ls *akefile &> /dev/null; then
                : ${TERMUX_PKG_MAKE_INSTALL_TARGET:="install"}:
                # Some packages have problem with parallell install, and it does not buy much, so use -j 1.
                if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
                        make -j 1 ${TERMUX_PKG_MAKE_INSTALL_TARGET}
                else
                        make -j 1 ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
                fi
        fi
}

termux_step_post_make_install () {
        return
}

termux_step_extract_into_massagedir () {
	TARBALL_ORIG=$TERMUX_PKG_PACKAGEDIR/${TERMUX_PKG_NAME}_orig.tar.gz

	# Build diff tar with what has changed during the build:
	cd $TERMUX_PREFIX
	$TERMUX_TAR -N $TERMUX_BUILD_TS_FILE -czf $TARBALL_ORIG .

	# Extract tar in order to massage it
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
	$TERMUX_TAR xf $TARBALL_ORIG
}

termux_step_massage () {
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX

	# Remove lib/charset.alias which is installed by gettext-using packages:
	rm -f lib/charset.alias

	# Remove non-english man pages:
	test -d share/man && (cd share/man; for f in `ls | grep -v man`; do rm -Rf $f; done )

	if [ -z ${TERMUX_PKG_KEEP_INFOPAGES+x} ]; then
		# Remove info pages:
		rm -Rf share/info
	fi

	# Remove other docs:
	rm -Rf share/doc share/locale

	# Remove old kept libraries (readline):
	find . -name '*.old' -delete

	# Remove static libraries:
	if [ $TERMUX_PKG_KEEP_STATIC_LIBRARIES = "false" ]; then
		find . -name '*.a' -delete
		find . -name '*.la' -delete
	fi

	# .. move over sbin to bin
	for file in sbin/*; do if test -f $file; then mv $file bin/; fi; done

	# file(1) may fail for certain unusual files, so disable pipefail
	set +e +o pipefail
        # Remove world permissions and add write permissions:
        find . -exec chmod u+w,o-rwx \{\} \;
	# .. strip binaries (setting them as writeable first)
	if [ "$TERMUX_DEBUG" = "" ]; then
                find . -type f | xargs file | grep -E "(executable|shared object)" | grep ELF | cut -f 1 -d : | xargs $STRIP --strip-unneeded --preserve-dates -R '.gnu.version*'
	fi
        # Fix shebang paths:
        for file in `find -L . -type f`; do
                head -c 100 $file | grep -E "^#\!.*\\/bin\\/.*" | grep -q -E -v "^#\! ?\\/system" && sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$TERMUX_PREFIX/bin/\2@" $file
        done
	set -e -o pipefail
        # Remove DT_ entries which the android 5.1 linker warns about:
	if [ "$TERMUX_DEBUG" = "" ]; then
		find . -type f -print0 | xargs -0 $TERMUX_ELF_CLEANER
	fi

	test ! -z "$TERMUX_PKG_RM_AFTER_INSTALL" && rm -Rf $TERMUX_PKG_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

        # Sub packages:
        if [ -d include -a -z "${TERMUX_PKG_NO_DEVELSPLIT}" ]; then
                # Add virtual -dev sub package if there are include files:
                _DEVEL_SUBPACKAGE_FILE=$TERMUX_PKG_TMPDIR/${TERMUX_PKG_NAME}-dev.subpackage.sh
                echo TERMUX_SUBPKG_INCLUDE=\"include share/man/man3 lib/pkgconfig share/aclocal $TERMUX_PKG_INCLUDE_IN_DEVPACKAGE\" > $_DEVEL_SUBPACKAGE_FILE
                echo TERMUX_SUBPKG_DESCRIPTION=\"Development files for ${TERMUX_PKG_NAME}\" >> $_DEVEL_SUBPACKAGE_FILE
		if [ -n "$TERMUX_PKG_DEVPACKAGE_DEPENDS" ]; then
			echo TERMUX_SUBPKG_DEPENDS=\"$TERMUX_PKG_NAME,$TERMUX_PKG_DEVPACKAGE_DEPENDS\" >> $_DEVEL_SUBPACKAGE_FILE
		else
			echo TERMUX_SUBPKG_DEPENDS=\"$TERMUX_PKG_NAME\" >> $_DEVEL_SUBPACKAGE_FILE
		fi
		if [ x$TERMUX_PKG_CONFLICTS != x ]; then
			# Assume that dev packages conflicts as well.
			echo "TERMUX_SUBPKG_CONFLICTS=${TERMUX_PKG_CONFLICTS}-dev" >> $_DEVEL_SUBPACKAGE_FILE
		fi
        fi
        # Now build all sub packages
        rm -Rf $TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages
	for subpackage in $TERMUX_PKG_BUILDER_DIR/*.subpackage.sh $TERMUX_PKG_TMPDIR/*subpackage.sh; do
                test ! -f $subpackage && continue
		SUB_PKG_NAME=`basename $subpackage .subpackage.sh`
                # Default value is same as main package, but sub package may override:
                TERMUX_SUBPKG_PLATFORM_INDEPENDENT=$TERMUX_PKG_PLATFORM_INDEPENDENT
                SUB_PKG_DIR=$TERMUX_TOPDIR/$TERMUX_PKG_NAME/subpackages/$SUB_PKG_NAME
                TERMUX_SUBPKG_DEPENDS=""
		TERMUX_SUBPKG_CONFLICTS=""
                SUB_PKG_MASSAGE_DIR=$SUB_PKG_DIR/massage/$TERMUX_PREFIX
		SUB_PKG_PACKAGE_DIR=$SUB_PKG_DIR/package
                mkdir -p $SUB_PKG_MASSAGE_DIR $SUB_PKG_PACKAGE_DIR

                . $subpackage

                for includeset in $TERMUX_SUBPKG_INCLUDE; do
                        _INCLUDE_DIRSET=`dirname $includeset`
                        test "$_INCLUDE_DIRSET" = "." && _INCLUDE_DIRSET=""
                        if [ -e $includeset -o -L $includeset ]; then
				# Add the -L clause to handle relative symbolic links:
                                mkdir -p $SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET
                                mv $includeset $SUB_PKG_MASSAGE_DIR/$_INCLUDE_DIRSET
                        fi
                done

                SUB_PKG_ARCH=$TERMUX_ARCH
                test -n "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" && SUB_PKG_ARCH=all

                cd $SUB_PKG_DIR/massage
                SUB_PKG_INSTALLSIZE=`du -sk . | cut -f 1`
		$TERMUX_TAR -cJf $SUB_PKG_PACKAGE_DIR/data.tar.xz .

                mkdir -p DEBIAN
		cd DEBIAN
                cat > control <<HERE
Package: $SUB_PKG_NAME
Architecture: ${SUB_PKG_ARCH}
Installed-Size: ${SUB_PKG_INSTALLSIZE}
Maintainer: $TERMUX_PKG_MAINTAINER
Version: $TERMUX_PKG_FULLVERSION
Description: $TERMUX_SUBPKG_DESCRIPTION
Homepage: $TERMUX_PKG_HOMEPAGE
HERE
                test ! -z "$TERMUX_SUBPKG_DEPENDS" && echo "Depends: $TERMUX_SUBPKG_DEPENDS" >> control
                test ! -z "$TERMUX_SUBPKG_CONFLICTS" && echo "Conflicts: $TERMUX_SUBPKG_CONFLICTS" >> control
		$TERMUX_TAR -cJf $SUB_PKG_PACKAGE_DIR/control.tar.xz .

                # Create the actual .deb file:
                TERMUX_SUBPKG_DEBFILE=$TERMUX_DEBDIR/${SUB_PKG_NAME}_${TERMUX_PKG_FULLVERSION}_${SUB_PKG_ARCH}.deb
		ar cr $TERMUX_SUBPKG_DEBFILE \
				   $TERMUX_COMMON_CACHEDIR/debian-binary \
				   $SUB_PKG_PACKAGE_DIR/control.tar.xz \
				   $SUB_PKG_PACKAGE_DIR/data.tar.xz
                if [ "$TERMUX_PROCESS_DEB" != "" ]; then
			$TERMUX_PROCESS_DEB $TERMUX_SUBPKG_DEBFILE
                fi

                # Go back to main package:
	        cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
	done

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
        # Make sure user can read and write all files (problem with dpkg otherwise):
        chmod -R u+rw .
}

termux_step_post_massage () {
        return
}

termux_step_create_debscripts () {
        return
}

termux_setup_golang () {
	export GOOS=android
	export CGO_ENABLED=1
	export GO_LDFLAGS="-extldflags=-pie"
	if [ "$TERMUX_ARCH" = "arm" ]; then
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		export GOARCH=386
		export GO386=sse2
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		export GOARCH=arm64
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		export GOARCH=amd64
	else
		echo "ERROR: Unsupported arch: $TERMUX_ARCH"
		exit 1
	fi

	local TERMUX_GO_VERSION=go1.6.2
	local TERMUX_GO_PLATFORM=linux-amd64
	test `uname` = "Darwin" && TERMUX_GO_PLATFORM=darwin-amd64

	export TERMUX_BUILDGO_FOLDER=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}
	export GOROOT=$TERMUX_BUILDGO_FOLDER
	export PATH=$GOROOT/bin:$PATH

	if [ -d $TERMUX_BUILDGO_FOLDER ]; then return; fi

	local TERMUX_BUILDGO_TAR=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
	rm -Rf $TERMUX_COMMON_CACHEDIR/go $TERMUX_BUILDGO_FOLDER
	termux_download https://storage.googleapis.com/golang/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz $TERMUX_BUILDGO_TAR
        ( cd $TERMUX_COMMON_CACHEDIR; tar xf $TERMUX_BUILDGO_TAR; mv go $TERMUX_BUILDGO_FOLDER; rm $TERMUX_BUILDGO_TAR )
}

source $TERMUX_PKG_BUILDER_SCRIPT

if [ -n "${TERMUX_PKG_BLACKLISTED_ARCHES:=""}" -a "$TERMUX_PKG_BLACKLISTED_ARCHES" != "${TERMUX_PKG_BLACKLISTED_ARCHES/$TERMUX_ARCH/}" ]; then
	echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
	exit 0
fi

echo "termux - building $1 for arch $TERMUX_ARCH..."
test -t 1 && printf "\033]0;$1...\007"

# Compute full version:
TERMUX_PKG_FULLVERSION=$TERMUX_PKG_VERSION
if [ "$TERMUX_PKG_BUILD_REVISION" != "0" -o "$TERMUX_PKG_FULLVERSION" != "${TERMUX_PKG_FULLVERSION/-/}" ]; then
	# "0" is the default revision, so only include it if the upstream versions contains "-" itself
	TERMUX_PKG_FULLVERSION+="-$TERMUX_PKG_BUILD_REVISION"
fi

# Start by extracting the package src into $TERMUX_PKG_SRCURL:
termux_step_extract_package
# Optional post processing:
termux_step_post_extract_package

# Optional host build:
if [ "x$TERMUX_PKG_HOSTBUILD" != "x" ]; then
	cd $TERMUX_PKG_SRCDIR
	for patch in $TERMUX_PKG_BUILDER_DIR/*.patch.beforehostbuild; do
		test -f $patch && sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $patch | patch --silent -p1
	done

        if [ -f "$TERMUX_PKG_HOSTBUILD_DIR/TERMUX_BUILT_FOR_$TERMUX_PKG_VERSION" ]; then
                echo "Using already built host build"
        else
                mkdir -p $TERMUX_PKG_HOSTBUILD_DIR	
                cd $TERMUX_PKG_HOSTBUILD_DIR

                ORIG_AR=$AR; unset AR
                ORIG_AS=$AS; unset AS
                ORIG_CC=$CC; unset CC
                ORIG_CXX=$CXX; unset CXX
                ORIG_CPP=$CPP; unset CPP
                ORIG_CFLAGS=$CFLAGS; unset CFLAGS
                ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
                ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
                ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
                ORIG_RANLIB=$RANLIB; unset RANLIB
                ORIG_LD=$LD; unset LD
                ORIG_PKG_CONFIG=$PKG_CONFIG; unset PKG_CONFIG
                ORIG_PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR; unset PKG_CONFIG_LIBDIR
                ORIG_STRIP=$STRIP; unset STRIP

                termux_step_host_build
                touch $TERMUX_PKG_HOSTBUILD_DIR/TERMUX_BUILT_FOR_$TERMUX_PKG_VERSION

                export AR=$ORIG_AR
                export AS=$ORIG_AS
                export CC=$ORIG_CC
                export CXX=$ORIG_CXX
                export CPP=$ORIG_CPP
                export CFLAGS=$ORIG_CFLAGS
                export CPPFLAGS=$ORIG_CPPFLAGS
                export CXXFLAGS=$ORIG_CXXFLAGS
                export LDFLAGS=$ORIG_LDFLAGS
                export RANLIB=$ORIG_RANLIB
                export LD=$ORIG_LD
                export PKG_CONFIG=$ORIG_PKG_CONFIG
                export PKG_CONFIG_LIBDIR=$ORIG_PKG_CONFIG_LIBDIR
                export STRIP=$ORIG_STRIP
        fi
fi

if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libandroid-support/}" ]; then
	# If using the android support library, link to it and include its headers as system headers:
	export CPPFLAGS="$CPPFLAGS -isystem $TERMUX_PREFIX/include/libandroid-support"
	export LDFLAGS="$LDFLAGS -landroid-support"
fi

if [ -n "$TERMUX_PKG_BUILD_IN_SRC" ]; then
	echo "Building in src due to TERMUX_PKG_BUILD_IN_SRC being set" >> $TERMUX_PKG_BUILDDIR/BUILDING_IN_SRC.txt
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
fi

cd $TERMUX_PKG_BUILDDIR
termux_step_patch_package
cd $TERMUX_PKG_BUILDDIR
termux_step_pre_configure
cd $TERMUX_PKG_BUILDDIR
termux_step_configure
cd $TERMUX_PKG_BUILDDIR
termux_step_post_configure
cd $TERMUX_PKG_BUILDDIR
termux_step_pre_make
cd $TERMUX_PKG_BUILDDIR
termux_step_make
cd $TERMUX_PKG_BUILDDIR
termux_step_make_install
cd $TERMUX_PKG_BUILDDIR
termux_step_post_make_install
cd $TERMUX_PKG_MASSAGEDIR
termux_step_extract_into_massagedir
cd $TERMUX_PKG_MASSAGEDIR
termux_step_massage
cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
termux_step_post_massage

# Create data tarball containing files to package:
cd $TERMUX_PKG_MASSAGEDIR
if [ "`find . -type f`" = "" ]; then
        echo "ERROR: No files in package"
        exit 1
fi
$TERMUX_TAR -cJf $TERMUX_PKG_PACKAGEDIR/data.tar.xz .

# Get install size. This will be written as the "Installed-Size" deb field so is measured in 1024-byte blocks:
TERMUX_PKG_INSTALLSIZE=`du -sk . | cut -f 1`

# Create deb package:
# NOTE: From here on TERMUX_ARCH is set to "all" if TERMUX_PKG_PLATFORM_INDEPENDENT is set by the package
test -n "$TERMUX_PKG_PLATFORM_INDEPENDENT" && TERMUX_ARCH=all

cd $TERMUX_PKG_MASSAGEDIR

mkdir -p DEBIAN
cat > DEBIAN/control <<HERE
Package: $TERMUX_PKG_NAME
Architecture: ${TERMUX_ARCH}
Installed-Size: ${TERMUX_PKG_INSTALLSIZE}
Maintainer: $TERMUX_PKG_MAINTAINER
Version: $TERMUX_PKG_FULLVERSION
Description: $TERMUX_PKG_DESCRIPTION
Homepage: $TERMUX_PKG_HOMEPAGE
HERE
test ! -z "$TERMUX_PKG_DEPENDS" && echo "Depends: $TERMUX_PKG_DEPENDS" >> DEBIAN/control
test ! -z "$TERMUX_PKG_ESSENTIAL" && echo "Essential: yes" >> DEBIAN/control
test ! -z "$TERMUX_PKG_CONFLICTS" && echo "Conflicts: $TERMUX_PKG_CONFLICTS" >> DEBIAN/control

# Create DEBIAN/conffiles (see https://www.debian.org/doc/debian-policy/ap-pkg-conffiles.html):
for f in $TERMUX_PKG_CONFFILES; do echo $TERMUX_PREFIX/$f >> DEBIAN/conffiles; done
# Allow packages to create arbitrary control files:
cd DEBIAN
termux_step_create_debscripts

# Create control.tar.xz
$TERMUX_TAR -cJf $TERMUX_PKG_PACKAGEDIR/control.tar.xz .
# In the .deb ar file there should be a file "debian-binary" with "2.0" as the content:
TERMUX_PKG_DEBFILE=$TERMUX_DEBDIR/${TERMUX_PKG_NAME}_${TERMUX_PKG_FULLVERSION}_${TERMUX_ARCH}.deb
# Create the actual .deb file:
ar cr $TERMUX_PKG_DEBFILE \
                   $TERMUX_COMMON_CACHEDIR/debian-binary \
                   $TERMUX_PKG_PACKAGEDIR/control.tar.xz \
                   $TERMUX_PKG_PACKAGEDIR/data.tar.xz

if [ "$TERMUX_PROCESS_DEB" != "" ]; then
	$TERMUX_PROCESS_DEB $TERMUX_PKG_DEBFILE
fi

echo "termux - build of '$1' done"
test -t 1 && printf "\033]0;$1 - DONE\007"
exit 0
