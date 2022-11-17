TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/lightning/
TERMUX_PKG_DESCRIPTION="A library to aid in making portable programs that compile assembly code at run time"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/lightning/lightning-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e3984ff1ccf0ba30a985211d40fc5c06b25f014ebdf3d80d0fe3d0c80dd7c0e
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ffsl=yes
"
