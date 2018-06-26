TERMUX_PKG_HOMEPAGE=https://ninja-build.org
TERMUX_PKG_DESCRIPTION="A small build system with a focus on speed"
TERMUX_PKG_VERSION=1.8.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=86b8700c3d0880c2b44c2ff67ce42774aaf8c28cbf57725cb881569288c1c6f4
TERMUX_PKG_SRCURL=https://github.com/ninja-build/ninja/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure.py
}

termux_step_make () {
	termux_setup_ninja
	ninja -j $TERMUX_MAKE_PROCESSES
}

termux_step_make_install () {
	cp ninja $TERMUX_PREFIX/bin
}
