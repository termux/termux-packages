TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-auth
TERMUX_PKG_DESCRIPTION="Password authentication library and utility for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-auth/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfe928b1c40822ad12d5673f37e464af237d74aef08c6b1187c5d8b96b848d52
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="termux-auth-dev"
TERMUX_PKG_REPLACES="termux-auth-dev"

termux_step_pre_configure() {
	CPPFLAGS+=" -DTERMUX_HOME=\\\"${TERMUX_ANDROID_HOME}\\\" -DTERMUX_PREFIX=\\\"${TERMUX_PREFIX}\\\""
}
