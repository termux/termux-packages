TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.24"
TERMUX_PKG_SRCURL=https://download.drobilla.net/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6bb6be9f88504176d0642f12de809b2b9e2dc55621a68adb8c7edb99aefabb4f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
