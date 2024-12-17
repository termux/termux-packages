TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:05.02.01"
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/remind-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=d242504ec0d15741a3ff6d9d41e194e4460a30bbfd7d15ee3d7f8da152a46450
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
