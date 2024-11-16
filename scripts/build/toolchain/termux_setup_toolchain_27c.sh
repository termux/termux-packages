termux_setup_toolchain_27c() {
	export CFLAGS=""
	export CPPFLAGS=""
	export LDFLAGS="-L${TERMUX_PREFIX}/lib"

	export AS=$TERMUX_HOST_PLATFORM-clang
	export CC=$TERMUX_HOST_PLATFORM-clang
	export CPP=$TERMUX_HOST_PLATFORM-cpp
	export CXX=$TERMUX_HOST_PLATFORM-clang++
	export LD=ld.lld
	export AR=llvm-ar
	export OBJCOPY=llvm-objcopy
	export OBJDUMP=llvm-objdump
	export RANLIB=llvm-ranlib
	export READELF=llvm-readelf
	export STRIP=llvm-strip
	export NM=llvm-nm
	export CXXFILT=llvm-cxxfilt

	export TERMUX_HASKELL_OPTIMISATION="-O"
	if [ "${TERMUX_DEBUG_BUILD}" = true ]; then
		TERMUX_HASKELL_OPTIMISATION="-O0"
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export PATH=$TERMUX_STANDALONE_TOOLCHAIN/bin:$PATH
		export CC_FOR_BUILD=gcc
		export PKG_CONFIG=$TERMUX_STANDALONE_TOOLCHAIN/bin/pkg-config
		export PKGCONFIG=$PKG_CONFIG
		export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM$TERMUX_PKG_API_LEVEL
		if [ $TERMUX_ARCH = arm ]; then
			CCTERMUX_HOST_PLATFORM=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL
		fi
		LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib"
	else
		export CC_FOR_BUILD=$CC
		# Some build scripts use environment variable 'PKG_CONFIG', so
		# using this for on-device builds too.
		export PKG_CONFIG=pkg-config
	fi
	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# https://developer.android.com/ndk/guides/standalone_toolchain.html#abi_compatibility:
		# "We recommend using the -mthumb compiler flag to force the generation of 16-bit Thumb-2 instructions".
		# With r13 of the ndk ruby 2.4.0 segfaults when built on arm with clang without -mthumb.
		CFLAGS+=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb"
		LDFLAGS+=" -march=armv7-a"
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		# From $NDK/docs/CPU-ARCH-ABIS.html:
		CFLAGS+=" -march=i686 -msse3 -mstackrealign -mfpmath=sse"
		# i686 seem to explicitly require -fPIC, see
		# https://github.com/termux/termux-packages/issues/7215#issuecomment-906154438
		CFLAGS+=" -fPIC"
		export GOARCH=386
		export GO386=sse2
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		export GOARCH=arm64
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		export GOARCH=amd64
	elif [ "$TERMUX_ARCH" = "riscv64" ]; then
		export GOARCH=riscv64
	else
		termux_error_exit "Invalid arch '$TERMUX_ARCH' - support arches are 'arm', 'i686', 'aarch64', 'x86_64', 'riscv64'"
	fi

	# Android 7 started to support DT_RUNPATH (but not DT_RPATH).
	LDFLAGS+=" -Wl,--enable-new-dtags"

	# Avoid linking extra (unneeded) libraries.
	LDFLAGS+=" -Wl,--as-needed"

	# Basic hardening.
	CFLAGS+=" -fstack-protector-strong"
	LDFLAGS+=" -Wl,-z,relro,-z,now"

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		CFLAGS+=" -g3 -O1"
		CPPFLAGS+=" -D_FORTIFY_SOURCE=2 -D__USE_FORTIFY_LEVEL=2"
	else
		CFLAGS+=" -Oz"
	fi

	export CXXFLAGS="$CFLAGS"
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include"

	# If libandroid-support is declared as a dependency, link to it explicitly:
	if [ "$TERMUX_PKG_DEPENDS" != "${TERMUX_PKG_DEPENDS/libandroid-support/}" ]; then
		LDFLAGS+=" -Wl,--no-as-needed,-landroid-support,--as-needed"
	fi

	export GOOS=android
	export CGO_ENABLED=1
	export GO_LDFLAGS="-extldflags=-pie"
	export CGO_LDFLAGS="${LDFLAGS/ -Wl,-z,relro,-z,now/}"
	export CGO_CFLAGS="-I$TERMUX_PREFIX/include"
	export RUSTFLAGS="-C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib -C link-arg=-Wl,--enable-new-dtags"

	export ac_cv_func_getpwent=no
	export ac_cv_func_endpwent=yes
	export ac_cv_func_getpwnam=no
	export ac_cv_func_getpwuid=no
	export ac_cv_func_sigsetmask=no
	export ac_cv_c_bigendian=no

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		return
	fi

	if [ -d $TERMUX_STANDALONE_TOOLCHAIN ]; then
		return
	fi

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

	for HOST_PLAT in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android riscv64-linux-android; do
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang++ \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++

		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$TERMUX_PKG_API_LEVEL-clang \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp
		sed -i 's|"$bin_dir/clang"|& -E|' \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp

		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-gcc
		cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++ \
			$_TERMUX_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-g++
	done

	cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL-clang \
		$_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang
	cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL-clang++ \
		$_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang++
	cp $_TERMUX_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi-cpp \
		$_TERMUX_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-cpp

	# rust 1.75.0+ expects this directory to be present
	rm -fr "${_TERMUX_TOOLCHAIN_TMPDIR}"/toolchains
	mkdir -p "${_TERMUX_TOOLCHAIN_TMPDIR}"/toolchains/llvm/prebuilt
	ln -fs ../../.. "${_TERMUX_TOOLCHAIN_TMPDIR}"/toolchains/llvm/prebuilt/linux-x86_64

	# Create a pkg-config wrapper. We use path to host pkg-config to
	# avoid picking up a cross-compiled pkg-config later on.
	local _HOST_PKGCONFIG
	_HOST_PKGCONFIG=$(command -v pkg-config)
	mkdir -p "$PKG_CONFIG_LIBDIR"
	cat > $_TERMUX_TOOLCHAIN_TMPDIR/bin/pkg-config <<-HERE
		#!/bin/sh
		export PKG_CONFIG_DIR=
		export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
		exec $_HOST_PKGCONFIG "\$@"
	HERE
	chmod +x "$_TERMUX_TOOLCHAIN_TMPDIR"/bin/pkg-config

	cd $_TERMUX_TOOLCHAIN_TMPDIR/sysroot
	for f in $TERMUX_SCRIPTDIR/ndk-patches/$TERMUX_NDK_VERSION/*.patch; do
		echo "Applying ndk-patch: $(basename $f)"
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" "$f" | \
			sed "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" | \
			patch --silent -p1;
	done
	# libintl.h: Inline implementation gettext functions.
	# langinfo.h: Inline implementation of nl_langinfo().
	cp "$TERMUX_SCRIPTDIR"/ndk-patches/{libintl.h,langinfo.h} usr/include

	# Remove <sys/capability.h> because it is provided by libcap.
	# Remove <sys/shm.h> from the NDK in favour of that from the libandroid-shmem.
	# Remove <sys/sem.h> as it doesn't work for non-root.
	# Remove <glob.h> as we currently provide it from libandroid-glob.
	# Remove <iconv.h> as it's provided by libiconv.
	# Remove <spawn.h> as it's only for future (later than android-27).
	# Remove <zlib.h> and <zconf.h> as we build our own zlib.
	# Remove unicode headers provided by libicu.
	# Remove KHR/khrplatform.h provided by mesa.
	# Remove EGL, GLES, GLES2, and GLES3 provided by mesa.
	# Remove execinfo provided by libandroid-execinfo.
	# Remove NDK vulkan headers.
	rm usr/include/{sys/{capability,shm,sem},{glob,iconv,spawn,zlib,zconf},KHR/khrplatform,execinfo}.h
	rm usr/include/unicode/{char16ptr,platform,ptypes,putil,stringoptions,ubidi,ubrk,uchar,uconfig,ucpmap,udisplaycontext,uenum,uldnames,ulocdata,uloc,umachine,unorm2,urename,uscript,ustring,utext,utf16,utf8,utf,utf_old,utypes,uvernum,uversion}.h
	rm -Rf usr/include/vulkan
	rm -Rf usr/include/{EGL,GLES{,2,3}}

	sed -i "s/define __ANDROID_API__ __ANDROID_API_FUTURE__/define __ANDROID_API__ $TERMUX_PKG_API_LEVEL/" \
		usr/include/android/api-level.h

	$TERMUX_ELF_CLEANER --api-level=$TERMUX_PKG_API_LEVEL usr/lib/*/*/*.so
	for dir in usr/lib/*; do
		# This seem to be needed when building rust
		# packages
		echo 'INPUT(-lunwind)' > $dir/libgcc.a
	done

	grep -lrw $_TERMUX_TOOLCHAIN_TMPDIR/sysroot/usr/include/c++/v1 -e '<version>' | xargs -n 1 sed -i 's/<version>/\"version\"/g'
	mv $_TERMUX_TOOLCHAIN_TMPDIR $TERMUX_STANDALONE_TOOLCHAIN
}
