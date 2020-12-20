TERMUX_PKG_HOMEPAGE=http://eradman.com/entrproject/
TERMUX_PKG_DESCRIPTION="Event Notify Test Runner - run arbitrary commands when files change"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.6
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/e/entr/entr_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=16de20820df4a38162354754487b1248c8711822c7342d2f6d4f28fbd4a38e6d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure
}

termux_step_make() {
	make install
}
