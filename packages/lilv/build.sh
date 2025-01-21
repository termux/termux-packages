TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.26"
TERMUX_PKG_SRCURL=https://download.drobilla.net/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=22feed30bc0f952384a25c2f6f4b04e6d43836408798ed65a8a934c055d5d8ac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, libzix, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
