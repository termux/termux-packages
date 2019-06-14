termux_step_setup_toolchain() {
	export PATH=$TERMUX_STANDALONE_TOOLCHAIN/bin:$PATH

	export CFLAGS=""
	export LDFLAGS="-L${TERMUX_PREFIX}/lib"

	export AS=${TERMUX_HOST_PLATFORM}-clang
	export CC=$TERMUX_HOST_PLATFORM-clang
	export CXX=$TERMUX_HOST_PLATFORM-clang++

	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM$TERMUX_PKG_API_LEVEL
	if [ $TERMUX_ARCH = arm ]; then
	       CCTERMUX_HOST_PLATFORM=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL
	fi
	export AR=$TERMUX_HOST_PLATFORM-ar
	export CPP=${TERMUX_HOST_PLATFORM}-cpp
	export CC_FOR_BUILD=gcc
	export LD=$TERMUX_HOST_PLATFORM-ld
	export OBJDUMP=$TERMUX_HOST_PLATFORM-objdump
	# Setup pkg-config for cross-compiling:
	export PKG_CONFIG=$TERMUX_STANDALONE_TOOLCHAIN/bin/${TERMUX_HOST_PLATFORM}-pkg-config
	export RANLIB=$TERMUX_HOST_PLATFORM-ranlib
	export READELF=$TERMUX_HOST_PLATFORM-readelf
	export STRIP=$TERMUX_HOST_PLATFORM-strip

	# Android 7 started to support DT_RUNPATH (but not DT_RPATH).
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# https://developer.android.com/ndk/guides/standalone_toolchain.html#abi_compatibility:
		# "We recommend using the -mthumb compiler flag to force the generation of 16-bit Thumb-2 instructions".
		# With r13 of the ndk ruby 2.4.0 segfaults when built on arm with clang without -mthumb.
		CFLAGS+=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb"
		LDFLAGS+=" -march=armv7-a"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		# From $NDK/docs/CPU-ARCH-ABIS.html:
		CFLAGS+=" -march=i686 -msse3 -mstackrealign -mfpmath=sse"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		:
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		:
	else
		termux_error_exit "Invalid arch '$TERMUX_ARCH' - support arches are 'arm', 'i686', 'aarch64', 'x86_64'"
	fi

	if [ -n "$TERMUX_DEBUG" ]; then
		CFLAGS+=" -g3 -O1 -fstack-protector --param ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
	else
		if [ $TERMUX_ARCH = arm ]; then
			CFLAGS+=" -Os"
		else
			CFLAGS+=" -Oz"
		fi
	fi

	export CXXFLAGS="$CFLAGS"
	export CPPFLAGS="-I${TERMUX_PREFIX}/include"

	# If libandroid-support is declared as a dependency, link to it explicitly:
	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libandroid-support/}" ]; then
		LDFLAGS+=" -landroid-support"
	fi

	export ac_cv_func_getpwent=no
	export ac_cv_func_getpwnam=no
	export ac_cv_func_getpwuid=no
	export ac_cv_func_sigsetmask=no
	export ac_cv_c_bigendian=no

	if [ ! -d $TERMUX_STANDALONE_TOOLCHAIN ]; then
		# Do not put toolchain in place until we are done with setup, to avoid having a half setup
		# toolchain left in place if something goes wrong (or process is just aborted):
		local _TERMUX_TOOLCHAIN_TMPDIR=${TERMUX_STANDALONE_TOOLCHAIN}-tmp
		rm -Rf $_TERMUX_TOOLCHAIN_TMPDIR

		local _NDK_ARCHNAME=$TERMUX_ARCH
		if [ "$TERMUX_ARCH" = "aarch64" ]; then
			_NDK_ARCHNAME=arm64
		elif [ "$TERMUX_ARCH" = "i686" ]; then
			_NDK_ARCHNAME=x86
		fi
		cp $NDK/toolchains/llvm/prebuilt/linux-x86_64 $_TERMUX_TOOLCHAIN_TMPDIR -r

		# Remove android-support header wrapping not needed on android-21:
		rm -Rf $_TERMUX_TOOLCHAIN_TMPDIR/sysroot/usr/local

		# Use gold by default to work around https://github.com/android-ndk/ndk/issues/148
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/aarch64-linux-android-ld.gold \
		    $_TERMUX_TOOLCHAIN_TMPDIR/bin/aarch64-linux-android-ld
		cp $_TERMUX_TOOLCHAIN_TMPDIR/aarch64-linux-android/bin/ld.gold \
		    $_TERMUX_TOOLCHAIN_TMPDIR/aarch64-linux-android/bin/ld

			# Linker wrapper script to add '--exclude-libs libgcc.a', see
			# https://github.com/android-ndk/ndk/issues/379
			# https://android-review.googlesource.com/#/c/389852/
			local linker
			for linker in ld ld.bfd ld.gold; do
				local wrap_linker=$_TERMUX_TOOLCHAIN_TMPDIR/arm-linux-androideabi/bin/$linker
				local real_linker=$_TERMUX_TOOLCHAIN_TMPDIR/arm-linux-androideabi/bin/$linker.real
				cp $wrap_linker $real_linker
				echo '#!/bin/bash' > $wrap_linker
				echo -n '$(dirname $0)/' >> $wrap_linker
				echo -n $linker.real >> $wrap_linker
				echo ' --exclude-libs libunwind.a --exclude-libs libgcc_real.a "$@"' >> $wrap_linker
			done
		for HOST_PLAT in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android; do

		# Setup the cpp preprocessor:
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang++ \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp
		sed -i 's/clang/clang -E/' \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-gcc 
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++ \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-gcc
		done
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL-clang \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang			
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL-clang++ \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang++
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi-cpp \
		   $_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-cpp

		cd $_TERMUX_TOOLCHAIN_TMPDIR/sysroot
		for f in $TERMUX_SCRIPTDIR/ndk-patches/*.patch; do
			sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" "$f" | \
				sed "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" | \
				patch --silent -p1;
		done
		# ifaddrs.h: Added in android-24 unified headers, use a inline implementation for now.
		# libintl.h: Inline implementation gettext functions.
		# langinfo.h: Inline implementation of nl_langinfo().
		cp "$TERMUX_SCRIPTDIR"/ndk-patches/{ifaddrs.h,libintl.h,langinfo.h} usr/include

		# Remove <sys/capability.h> because it is provided by libcap-dev.
		# Remove <sys/shm.h> from the NDK in favour of that from the libandroid-shmem.
		# Remove <sys/sem.h> as it doesn't work for non-root.
		# Remove <glob.h> as we currently provide it from libandroid-glob.
		# Remove <iconv.h> as it's provided by libiconv.
		# Remove <spawn.h> as it's only for future (later than android-27).
		# Remove <zlib.h> and <zconf.h> as we build our own zlib
		rm usr/include/sys/{capability.h,shm.h,sem.h} usr/include/{glob.h,iconv.h,spawn.h,zlib.h,zconf.h}

		sed -i "s/define __ANDROID_API__ __ANDROID_API_FUTURE__/define __ANDROID_API__ $TERMUX_PKG_API_LEVEL/" \
			usr/include/android/api-level.h

		$TERMUX_ELF_CLEANER usr/lib/*/*/*.so

		grep -lrw $_TERMUX_TOOLCHAIN_TMPDIR/sysroot/usr/include/c++/v1 -e '<version>'   | xargs -n 1 sed -i 's/<version>/\"version\"/g'
		mv $_TERMUX_TOOLCHAIN_TMPDIR $TERMUX_STANDALONE_TOOLCHAIN
	fi

	# On Android 7, libutil functionality is provided by libc.
	# But many programs still may search for libutil.
	if [ ! -f $TERMUX_PREFIX/lib/libutil.so ]; then
		mkdir -p "$TERMUX_PREFIX/lib"
		echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/libutil.so
	fi

	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"
	# Create a pkg-config wrapper. We use path to host pkg-config to
	# avoid picking up a cross-compiled pkg-config later on.
	local _HOST_PKGCONFIG
	_HOST_PKGCONFIG=$(which pkg-config)
	mkdir -p $TERMUX_STANDALONE_TOOLCHAIN/bin "$PKG_CONFIG_LIBDIR"
	cat > "$PKG_CONFIG" <<-HERE
		#!/bin/sh
		export PKG_CONFIG_DIR=
		export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
		exec $_HOST_PKGCONFIG "\$@"
	HERE
	chmod +x "$PKG_CONFIG"
}
