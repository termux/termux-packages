TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-auth
TERMUX_PKG_DESCRIPTION="Password authentication library and utility for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/termux/termux-auth/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=539bc4f8271878d3402e8f54030441e345cfb8d0d635fa59c541f51d21e939d0
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="termux-auth-dev"
TERMUX_PKG_REPLACES="termux-auth-dev"

termux_step_pre_configure() {
	CPPFLAGS+=" -DTERMUX_HOME=\\\"${TERMUX_ANDROID_HOME}\\\" -DTERMUX_PREFIX=\\\"${TERMUX_PREFIX}\\\""
}
