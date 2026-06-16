TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.28.0"
TERMUX_PKG_SRCURL=https://download.drobilla.net/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8dcb70adb5cf072335115a6b091f4113710bdc73abaadaa3f9e9c1e55957b149
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, libzix, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
