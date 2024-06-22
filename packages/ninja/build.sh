TERMUX_PKG_HOMEPAGE=https://ninja-build.org
TERMUX_PKG_DESCRIPTION="A small build system with a focus on speed"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.1"
TERMUX_PKG_SRCURL=https://github.com/ninja-build/ninja/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=821bdff48a3f683bc4bb3b6f0b5fe7b2d647cf65d52aeb63328c91a6c6df285a
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-spawn"
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure.py
}

termux_step_make() {
	if $TERMUX_ON_DEVICE_BUILD; then
		$TERMUX_PKG_SRCDIR/configure.py --bootstrap
	else
		termux_setup_ninja
		ninja -j $TERMUX_PKG_MAKE_PROCESSES
	fi
}

termux_step_make_install() {
	cp ninja $TERMUX_PREFIX/bin
}
