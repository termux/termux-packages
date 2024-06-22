TERMUX_PKG_HOMEPAGE=https://libmpeg2.sourceforge.io/
TERMUX_PKG_DESCRIPTION="MPEG-2 decoder libraries"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.1"
TERMUX_PKG_SRCURL=https://libmpeg2.sourceforge.io/files/libmpeg2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4

termux_step_pre_configure() {
	autoreconf -vfi
}
