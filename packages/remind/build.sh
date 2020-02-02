TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1:03.03.00
TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/remind/download/remind-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=96895b981ae59c3ba136c59ad54bccaa4fb959197f371aff4eb16eca81b3b61a
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
