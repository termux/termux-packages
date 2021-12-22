TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0
TERMUX_PKG_SRCURL=http://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2a87bb7d9e5e89b6f614495937b557dbb8144ea53d0c1fa1812388982cd41ebb
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}

termux_step_make() {
	make install
}
