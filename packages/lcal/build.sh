TERMUX_PKG_HOMEPAGE=https://pcal.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A multi-platform program which generates PostScript lunar calendars in a yearly format"
# The original calendar PostScript was Copyright (c) 1987 by Patrick Wood
# and Pipeline Associates, Inc. with permission to modify and redistribute.
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="ReadMe.txt, COPYRIGHT.moonphase"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcal/lcal-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=c3c4c2bdec5f5129004385f06960f56bc0e3671ae835ee39044598fb76480f70
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/COPYRIGHT.moonphase ./
}

termux_step_make() {
	make CC="$CC"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./lcal
	install -Dm700 -T ./lcal.man $TERMUX_PREFIX/share/man/man1/lcal.1
}
