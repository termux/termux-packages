TERMUX_PKG_HOMEPAGE=https://ninja-build.org
TERMUX_PKG_DESCRIPTION="A small build system with a focus on speed"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL=https://github.com/ninja-build/ninja/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f08641d00099a9e40d44ec0146f841c472ae58b7e6dd517bee3945cfd923cedf
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
