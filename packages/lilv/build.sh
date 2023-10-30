TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/lilv.html
TERMUX_PKG_DESCRIPTION="A C library to make the use of LV2 plugins as simple as possible for applications"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.22"
TERMUX_PKG_SRCURL=https://download.drobilla.net/lilv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=76f949d0e59fc83363409b5ec5e15c1046fb7dd6589d3c1b920cec1fd29f9ff3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsndfile, lv2, serd, sord, sratom"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbindings_py=disabled
"
