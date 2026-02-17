TERMUX_PKG_HOMEPAGE=https://github.com/OpenSC/libp11
TERMUX_PKG_DESCRIPTION="PKCS#11 wrapper library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.18"
TERMUX_PKG_SRCURL=https://github.com/OpenSC/libp11/releases/download/libp11-${TERMUX_PKG_VERSION}/libp11-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9292de67ca73aba1deacf577c9086b595765f36ef47712cfeb49fa31f6e772fb
TERMUX_PKG_AUTO_UPDATE=true
# Make sure we strip off the entire `libp11-` prefix from the tag name.
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/^libp11-//'
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
