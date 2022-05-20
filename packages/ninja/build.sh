TERMUX_PKG_HOMEPAGE=https://ninja-build.org
TERMUX_PKG_DESCRIPTION="A small build system with a focus on speed"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL=https://github.com/ninja-build/ninja/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c6ba2e66400fe3f1ae83deb4b235faf3137ec20bd5b08c29bfc368db143e4c6
TERMUX_PKG_AUTO_UPDATE=true
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
