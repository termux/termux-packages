TERMUX_PKG_HOMEPAGE="https://think-async.com/Asio"
TERMUX_PKG_DESCRIPTION="Cross-platform C++ library for network and low-level I/O programming"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.22.2"
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/project/asio/asio/$TERMUX_PKG_VERSION%20%28Stable%29/asio-$TERMUX_PKG_VERSION.tar.bz2"
TERMUX_PKG_SHA256=776bb781eee8022a3eed71de28f05bf8ba09741db2e57ad8cc420aa0884cbc6c
TERMUX_PKG_DEPENDS='openssl, boost'
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	sed --in-place -e 's/-lrt//' configure.ac
	autoreconf -fi
}
