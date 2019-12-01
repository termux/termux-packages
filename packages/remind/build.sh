TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.1.17
TERMUX_PKG_SHA256=c955c196ffd368720fc4af91823f88d66a47be8d28736f279918ab64a460fe51
TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/remind/download/remind-0${TERMUX_PKG_VERSION:0:1}.0${TERMUX_PKG_VERSION:2:1}.${TERMUX_PKG_VERSION:4:2}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
