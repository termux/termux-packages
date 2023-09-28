TERMUX_PKG_HOMEPAGE=https://libtorrent.org/
TERMUX_PKG_DESCRIPTION="A feature complete C++ bittorrent implementation focusing on efficiency and scalability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/arvidn/libtorrent/releases/download/v${TERMUX_PKG_VERSION}/libtorrent-rasterbar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e
TERMUX_PKG_DEPENDS="boost, libc++, openssl, python"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dboost-python-module-name=python
-Dpython-bindings=ON
"
