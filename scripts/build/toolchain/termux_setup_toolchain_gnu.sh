termux_setup_toolchain_gnu() {
	export CFLAGS="-O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -fstack-clash-protection"
	export CPPFLAGS=""
	export LDFLAGS=""

	export CC=$TERMUX_HOST_PLATFORM-gcc
	export CXX=$TERMUX_HOST_PLATFORM-g++
	export AR=$TERMUX_HOST_PLATFORM-gcc-ar
	export RANLIB=$TERMUX_HOST_PLATFORM-gcc-ranlib
	export NM=$TERMUX_HOST_PLATFORM-gcc-nm
	export LD=ld
	export AS=as
	export OBJCOPY=objcopy
	export OBJDUMP=objdump
	export READELF=readelf
	export STRIP=strip
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		export CXXFILT=c++filt
	else
		export CXXFILT=$TERMUX_HOST_PLATFORM-c++filt
	fi

	if [ ! -d "$TERMUX_PREFIX/lib/" ]; then
		termux_error_exit "glibc library directory was not found ('$TERMUX_PREFIX/lib/')"
	fi
	if [ ! -d "$TERMUX_PREFIX/include/" ]; then
		termux_error_exit "glibc header directory was not found ('$TERMUX_PREFIX/include/')"
	fi

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a"
		export DYNAMIC_LINKER="ld-linux-aarch64.so.1"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS+=" -march=armv7-a -mfloat-abi=hard -mfpu=neon"
		export DYNAMIC_LINKER="ld-linux-armhf.so.3"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		CFLAGS+=" -march=x86-64 -fPIC"
		export DYNAMIC_LINKER="ld-linux-x86-64.so.2"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		CFLAGS+=" -march=i686"
		export DYNAMIC_LINKER="ld-linux.so.2"
	fi
	export PATH_DYNAMIC_LINKER="$TERMUX_PREFIX/lib/$DYNAMIC_LINKER"

	if [ ! -f "$PATH_DYNAMIC_LINKER" ]; then
		termux_error_exit "glibc dynamic linker was not found ('$PATH_DYNAMIC_LINKER')"
	fi

	case "$TERMUX_ARCH" in
		"aarch64"|"arm") CFLAGS+=" -fstack-protector-strong";;
		"x86_64"|"i686") CFLAGS+=" -mtune=generic -fcf-protection";;
	esac

 	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM

	export PKG_CONFIG=pkg-config
	export PKGCONFIG=$PKG_CONFIG
 	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if ! $(echo "$PATH" | grep -q "^$TERMUX_STANDALONE_TOOLCHAIN/bin:"); then
			export PATH="$TERMUX_STANDALONE_TOOLCHAIN/bin:$PATH"
		fi
  		if ! $(echo "$PATH" | grep -q ":$TERMUX_PREFIX/bin"); then
			export PATH="$PATH:$TERMUX_PREFIX/bin"
		fi
	fi

	export CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
}
