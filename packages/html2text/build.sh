TERMUX_PKG_HOMEPAGE=http://www.mbayer.de/html2text/
TERMUX_PKG_DESCRIPTION="Utility that converts HTML documents into plain text"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.4.0"
TERMUX_PKG_SRCURL=https://gitlab.com/grobian/html2text/-/archive/v${TERMUX_PKG_VERSION:2}/html2text-v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=8c8689b1bc33677168b5f530865b0935f73ab5ec2341cf81122c452047f1b464
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
