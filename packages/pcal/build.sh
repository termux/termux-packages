TERMUX_PKG_HOMEPAGE=https://pcal.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A multi-platform program which generates annotated PostScript or HTML calendars in a monthly or yearly format"
# The original calendar PostScript was Copyright (c) 1987 by Patrick Wood
# and Pipeline Associates, Inc. with permission to modify and redistribute.
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="doc/ReadMe.txt, COPYRIGHT.moonphase"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.11.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pcal/pcal-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=8406190e7912082719262b71b63ee31a98face49aa52297db96cc0c970f8d207
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/COPYRIGHT.moonphase ./
}

termux_step_make() {
	make CC="$CC"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./exec/pcal
	install -Dm700 -T ./doc/pcal.man $TERMUX_PREFIX/share/man/man1/pcal.1
}
