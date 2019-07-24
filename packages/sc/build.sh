TERMUX_PKG_HOMEPAGE="http://www.ibiblio.org/pub/Linux/apps/financial/spreadsheet/!INDEX.html"
TERMUX_PKG_DESCRIPTION="A vi-like spreadsheet calculator"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=7.16
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://www.ibiblio.org/pub/Linux/apps/financial/spreadsheet/sc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1997a00b6d82d189b65f6fd2a856a34992abc99e50d9ec463bbf1afb750d1765
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="SIMPLE=-DSIMPLE"

termux_step_post_configure () {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
}
