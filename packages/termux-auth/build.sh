TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-auth
TERMUX_PKG_DESCRIPTION="Password authentication library and utility for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/termux/termux-auth/archive/a7f557c40d0cf05e4c086ec04ae2544136c83b79.tar.gz
TERMUX_PKG_SHA256=af9d06cbea60ede83da32315ad8d6046ea803de2a182a2a9e472a554204ab830
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="termux-auth-dev"
TERMUX_PKG_REPLACES="termux-auth-dev"

termux_step_pre_configure() {
	CPPFLAGS+=" -DTERMUX_HOME=\\\"${TERMUX_ANDROID_HOME}\\\" -DTERMUX_PREFIX=\\\"${TERMUX_PREFIX}\\\""
}
