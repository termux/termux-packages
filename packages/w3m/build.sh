TERMUX_PKG_HOMEPAGE=http://w3m.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Text based Web browser and pager"
TERMUX_PKG_VERSION=0.5.3
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/w3m/w3m/w3m-$TERMUX_PKG_VERSION/w3m-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libgc, ncurses, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes"
