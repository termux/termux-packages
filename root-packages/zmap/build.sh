TERMUX_PKG_HOMEPAGE=https://zmap.io/
TERMUX_PKG_DESCRIPTION="A fast single packet network scanner designed for Internet-wide network surveys"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0-beta1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/zmap/zmap/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c97c452930ad6af95ad9ad79e66fea742f904b8e102c185f1001822cc5b5ceb3
TERMUX_PKG_DEPENDS="json-c, libgmp, libpcap, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DRESPECT_INSTALL_PREFIX_CONFIG=ON
"
