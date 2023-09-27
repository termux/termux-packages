TERMUX_PKG_HOMEPAGE="https://geographiclib.sourceforge.io"
TERMUX_PKG_DESCRIPTION="Utilities and C++ library to solve some geodesic problems"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/geographiclib/files/distrib-C%2B%2B/GeographicLib-$TERMUX_PKG_VERSION.tar.gz/download"
TERMUX_PKG_SHA256=96bd68ae77288fbbffd854c1c8f2c2981dbdbc7670753013fe5ce9ce86d8a125
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_BOTH_LIBS=OFF
"
