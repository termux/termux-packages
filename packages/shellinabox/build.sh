TERMUX_PKG_HOMEPAGE=https://github.com/shellinabox/shellinabox
TERMUX_PKG_DESCRIPTION="Implementation of a web server that can export arbitrary command line tools to a web based terminal emulator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/shellinabox/shellinabox/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e
TERMUX_PKG_AUTO_UPDATE=true
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
