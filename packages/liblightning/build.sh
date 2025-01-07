TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/lightning/
TERMUX_PKG_DESCRIPTION="A library to aid in making portable programs that compile assembly code at run time"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.3"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/lightning/lightning-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c045c7a33a00affbfeb11066fa502c03992e474a62ba95977aad06dbc14c6829
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ffsl=yes
"
