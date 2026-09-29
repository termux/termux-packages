TERMUX_PKG_HOMEPAGE=https://github.com/OpenSC/OpenSC
TERMUX_PKG_DESCRIPTION="Open source smart card tools and middleware"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.27.1"
TERMUX_PKG_SRCURL="https://github.com/OpenSC/OpenSC/releases/download/${TERMUX_PKG_VERSION}/opensc-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=976f4a23eaf3397a1a2c3a7aac80bf971a8c3d829c9a79f06145bfaeeae5eca7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libpcsclite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
CFLAGS=-I$TERMUX_PREFIX/include/PCSC
"

termux_step_pre_configure() {
	autoreconf -vfi
}
