TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.5"
TERMUX_PKG_SRCURL=https://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=128c0ce2efea5ae6bd3fd33c3cd31e161eb0c02609d8717ad37e95b41656e526
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}
