TERMUX_PKG_HOMEPAGE=https://dianne.skoll.ca/projects/remind/
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:06.02.10"
TERMUX_PKG_SRCURL=https://dianne.skoll.ca/projects/remind/download/remind-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=746aa587e72c32393037773fac976b6b7b29878f4eb8a728ad87f729d9a3efe6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
