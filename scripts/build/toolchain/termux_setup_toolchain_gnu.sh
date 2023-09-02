termux_setup_toolchain_gnu() {
	export CFLAGS="-O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -fstack-clash-protection"
	export CPPFLAGS=""
	export LDFLAGS=""

	export CC=$TERMUX_HOST_PLATFORM-gcc
	export CXX=$TERMUX_HOST_PLATFORM-g++
	export CPP="$TERMUX_HOST_PLATFORM-c++ -E"
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

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS+=" -march=armv7-a -mfloat-abi=hard -mfpu=neon"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		CFLAGS+=" -march=x86-64"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		CFLAGS+=" -march=i686"
	fi

	case "$TERMUX_ARCH" in
		"aarch64"|"arm") CFLAGS+=" -fstack-protector-strong";;
		"x86_64"|"i686") CFLAGS+=" -mtune=generic -fcf-protection";;
	esac

	export PKG_CONFIG=pkg-config
	export PKGCONFIG=$PKG_CONFIG
 	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"

	export CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
}
