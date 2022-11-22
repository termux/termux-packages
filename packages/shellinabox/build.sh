TERMUX_PKG_HOMEPAGE=https://github.com/shellinabox/shellinabox
TERMUX_PKG_DESCRIPTION="Implementation of a web server that can export arbitrary command line tools to a web based terminal emulator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.21
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/s/shellinabox/shellinabox_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4ec657182b3ec628c2a7b036b360011cef51a23104b2eb332eafede56528a632
TERMUX_PKG_DEPENDS="openssl, openssl-tool, termux-auth (>= 1.2), zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-login
--disable-pam
--disable-utmp
--disable-runtime-loading
"

termux_step_pre_configure() {
	export LIBS="-lssl -lcrypto"
	autoreconf -i
}
