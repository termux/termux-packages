TERMUX_PKG_HOMEPAGE=http://dtach.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Emulates the detach feature of screen"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/dtach/dtach-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32e9fd6923c553c443fab4ec9c1f95d83fa47b771e6e1dafb018c567291492f3

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/bin dtach
	install -Dm600 -t ${TERMUX_PREFIX}/share/man/man1 ${TERMUX_PKG_SRCDIR}/dtach.1
}
