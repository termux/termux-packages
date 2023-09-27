TERMUX_PKG_HOMEPAGE=https://zmap.io/
TERMUX_PKG_DESCRIPTION="A fast single packet network scanner designed for Internet-wide network surveys"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.0.0
TERMUX_PKG_SRCURL=https://github.com/zmap/zmap/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=e3151cdcdf695ab7581e01a7c6ee78678717d6a62ef09849b34db39682535454
TERMUX_PKG_DEPENDS="json-c, libgmp, libpcap, libunistring"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DRESPECT_INSTALL_PREFIX_CONFIG=ON
"
