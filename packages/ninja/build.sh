TERMUX_PKG_HOMEPAGE=https://ninja-build.org
TERMUX_PKG_DESCRIPTION="A small build system with a focus on speed"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SRCURL=https://github.com/ninja-build/ninja/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3810318b08489435f8efc19c05525e80a993af5a55baa0dfeae0465a9d45f99f
TERMUX_PKG_DEPENDS="libc++, libandroid-spawn"

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
		ninja -j $TERMUX_MAKE_PROCESSES
	fi
}

termux_step_make_install() {
	cp ninja $TERMUX_PREFIX/bin
}
