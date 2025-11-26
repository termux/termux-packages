TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.26.2"
TERMUX_PKG_SRCURL=https://download.drobilla.net/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9c712f7c44ba8b1fdbf9bbaa793bbf76844be40b361c4322bdaa5c4ed36c6b89
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, libzix, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
