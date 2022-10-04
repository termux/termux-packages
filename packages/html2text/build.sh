TERMUX_PKG_HOMEPAGE=http://www.mbayer.de/html2text/
TERMUX_PKG_DESCRIPTION="Utility that converts HTML documents into plain text"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/grobian/html2text/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=be16ec8ceb25f8e7fe438bd6e525b717d5de51bd0797eeadda0617087f1563c9
TERMUX_PKG_DEPENDS="libc++, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CXX="$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS"
	mkdir -p $TERMUX_PREFIX/share/man/man1
}
