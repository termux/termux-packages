TERMUX_PKG_HOMEPAGE="https://www.fresse.org/dateutils/"
TERMUX_PKG_DESCRIPTION="Command line date and time utilities"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.12"
TERMUX_PKG_SRCURL=https://github.com/hroptatyr/dateutils/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e5e2fecc64373d10ad40353c318313e32a68f6a99f29d37f83dcf948f5797149
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
