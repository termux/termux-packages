TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/ascii/
TERMUX_PKG_DESCRIPTION="List ASCII idiomatic names and octal/decimal code-point forms"
TERMUX_PKG_LICENSE=BSD-2-Clause
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.30
TERMUX_PKG_SRCURL=https://gitlab.com/esr/ascii/-/archive/$TERMUX_PKG_VERSION/ascii-$TERMUX_PKG_VE>
TERMUX_PKG_SHA256=8753ddf7ef4f477af50f69208fab09e5dad85033e04611de94b6b679ce59b001
TERMUX_PKG_LICENSE_FILE=COPYING
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make
}

termux_step_make_install() {
	make DESTDIR=$TERMUX__PREFIX PREFIX= install
}