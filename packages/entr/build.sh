TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.6"
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0222b8df928d3b5a3b5194d63e7de098533e04190d9d9a154b926c6c1f9dd14e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
