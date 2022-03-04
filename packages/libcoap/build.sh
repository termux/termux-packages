TERMUX_PKG_HOMEPAGE=https://libcoap.net/
TERMUX_PKG_DESCRIPTION="Implementation of CoAP, a lightweight protocol for resource constrained devices"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/obgm/libcoap/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1a195adacd6188d3b71c476e7b21706fef7f3663ab1fb138652e8da49a9ec556
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="libcoap-dev"
TERMUX_PKG_REPLACES="libcoap-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-openssl --disable-doxygen"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
