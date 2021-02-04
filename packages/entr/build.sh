TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.7
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/e/entr/entr_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=b6c1ab7644d83bb2a269dc74160867a3be0f5df116c7eb453c25053173534429
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}

termux_step_make() {
	make install
}
