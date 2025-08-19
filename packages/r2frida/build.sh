TERMUX_PKG_HOMEPAGE=https://github.com/nowsecure/r2frida
TERMUX_PKG_DESCRIPTION="Frida IO plugin for radare2"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8.6"
TERMUX_PKG_SRCURL=https://github.com/nowsecure/r2frida/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c65979581dc514e58639b5c9492ed21780370446fad6d8cfcaaffe25e86366f1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=--with-precompiled-agent
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="radare2"
TERMUX_PKG_BUILD_DEPENDS="radare2"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_pre_configure () {
	unset CXXFLAGS
	unset CPPFLAGS
	unset LDFLAGS
	unset CFLAGS
}

termux_step_make() {
	make frida_os=android frida_arch=arm64
}

termux_step_make_install() {
	cp -f src/r2frida-compile ${TERMUX_PREFIX}/bin
	mkdir -p ${TERMUX_PREFIX}/lib/radare2/last
	cp -f io_frida.so ${TERMUX_PREFIX}/lib/radare2/last
}
