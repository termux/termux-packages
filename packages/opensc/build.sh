TERMUX_PKG_HOMEPAGE=https://github.com/OpenSC/OpenSC
TERMUX_PKG_DESCRIPTION="Open source smart card tools and middleware"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.26.1
TERMUX_PKG_SRCURL="https://github.com/OpenSC/OpenSC/releases/download/${TERMUX_PKG_VERSION}/opensc-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f16291a031d86e570394762e9f35eaf2fcbc2337a49910f3feae42d54e1688cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libpcsclite"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
CFLAGS=-I$TERMUX_PREFIX/include/PCSC
"

termux_step_pre_configure() {
	autoreconf -vfi
}
