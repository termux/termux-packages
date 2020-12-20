TERMUX_PKG_HOMEPAGE=https://timewarrior.net/
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
_LIBSHARED_COMMIT=0d4e31de757ea2609a82549c5b09703d3d3fbe16
TERMUX_PKG_SRCURL=(https://github.com/GothenburgBitFactory/timewarrior/archive/v${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/GothenburgBitFactory/libshared/archive/${_LIBSHARED_COMMIT}.tar.gz)
TERMUX_PKG_SHA256=(bedfa22af67fd382ea2d5d470b40079122474ba86482fb11ff06cec98bb1433c
		   c37f52fc39c62b3391a0eae061cef2c4079dfd4af0e3bdabac1be98316f9c451)
TERMUX_PKG_DEPENDS="libandroid-glob, libc++"

termux_step_post_get_source() {
	rmdir src/libshared
	mv libshared-${_LIBSHARED_COMMIT}/ src/libshared
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

