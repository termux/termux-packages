TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:05.00.02"
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/remind-${TERMUX_PKG_VERSION:2}.tar.xz
TERMUX_PKG_SHA256=82352e2edf41ea186f66160f42c0f2ed4394e76b3f6001d52aa758c44edc0d62
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
