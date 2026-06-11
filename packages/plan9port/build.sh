TERMUX_PKG_HOMEPAGE=https://github.com/9fans/plan9port
TERMUX_PKG_DESCRIPTION="A port of many Plan 9 libraries and programs to Unix"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/9fans/plan9port/archive/b36c747d62a690ffb9cff6f17fbe207b23aa4b84.tar.gz
TERMUX_PKG_SHA256=b3c5dc0f2813c6f51178ada1765b6771910060ec3efaa8f05ea3f93c0334b5a8
TERMUX_PKG_DEPENDS="libresolv-wrapper"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	./INSTALL
}

termux_step_make_install() {
	cp -a . ${TERMUX_PREFIX}/plan9
	ln -s ../plan9/bin/9 ${TERMUX_PREFIX}/bin/9
}
