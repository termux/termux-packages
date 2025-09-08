TERMUX_PKG_HOMEPAGE="https://www.fresse.org/dateutils/"
TERMUX_PKG_DESCRIPTION="Command line date and time utilities"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/hroptatyr/dateutils/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9041b220b8cdb0e4e12292d8f71e7ad65fffd67873e96a3e52bfd226240deaec
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='--with-old-links=no'

termux_step_host_build() {
	pushd $TERMUX_PKG_SRCDIR
	autoreconf -fi
	./configure
	make -C build-aux yuck-bootstrap yuck.yucc yuck

	# Cleanup Makefile to prevent compiling with host parameters
	find -name Makefile -exec rm {} \;
	popd
}
