TERMUX_PKG_HOMEPAGE="https://github.com/nelhage/reptyr"
TERMUX_PKG_DESCRIPTION="Tool for reparenting a running program to a new terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/nelhage/reptyr/archive/refs/tags/reptyr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4b470ed2a0d25fed591739fa9613ce7ad3d0377891eb56cbe914e3c85db46ca8
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/bin reptyr
	install -Dm600 -t ${TERMUX_PREFIX}/share/man/man1 ${TERMUX_PKG_SRCDIR}/reptyr.1
}
