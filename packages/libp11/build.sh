TERMUX_PKG_HOMEPAGE=https://github.com/OpenSC/libp11
TERMUX_PKG_DESCRIPTION="PKCS#11 wrapper library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.21"
TERMUX_PKG_SRCURL=https://github.com/OpenSC/libp11/releases/download/libp11-${TERMUX_PKG_VERSION}/libp11-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efdb523aef8613d447e6a2d38227d4b389866f4bcf4b503130acd7f759490847
TERMUX_PKG_AUTO_UPDATE=true
# Make sure we strip off the entire `libp11-` prefix from the tag name.
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/^libp11-//'
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
