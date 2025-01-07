TERMUX_PKG_HOMEPAGE=https://libcoap.net/
TERMUX_PKG_DESCRIPTION="Implementation of CoAP, a lightweight protocol for resource constrained devices"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.5-rc3"
TERMUX_PKG_SRCURL=https://github.com/obgm/libcoap/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=344f69f0cb9a07ee6c068fc4987c2c6f1409cb1d569d5da7f727c8af3923fa26
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BREAKS="libcoap-dev"
TERMUX_PKG_REPLACES="libcoap-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-openssl --disable-doxygen"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
