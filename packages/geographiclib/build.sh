TERMUX_PKG_HOMEPAGE="https://geographiclib.sourceforge.io"
TERMUX_PKG_DESCRIPTION="Utilities and C++ library to solve some geodesic problems"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/geographiclib/files/distrib-C%2B%2B/GeographicLib-$TERMUX_PKG_VERSION.tar.gz/download"
TERMUX_PKG_SHA256=b062b472dae3d371b3005f4ea2fc59af687b8ea76eb23df732ec11c500fba959
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_BOTH_LIBS=OFF
"
