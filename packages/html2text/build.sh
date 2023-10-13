TERMUX_PKG_HOMEPAGE=http://www.mbayer.de/html2text/
TERMUX_PKG_DESCRIPTION="Utility that converts HTML documents into plain text"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.2.3"
TERMUX_PKG_SRCURL=https://github.com/grobian/html2text/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=29e4b04e7cc7b9b6acb7db76edf4739d3a72a672f37452267e707d40249520ee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CXX="$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS"
	mkdir -p $TERMUX_PREFIX/share/man/man1
	aclocal
	autoconf
	automake --force-missing --add-missing
}
