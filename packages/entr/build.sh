TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1
TERMUX_PKG_SRCURL=http://eradman.com/entrproject/code/entr-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0f87f577bce87641c525addb9bcc60bbaa579fe981dab759043e3ce1556dbb92
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}

termux_step_make() {
	make install
}
