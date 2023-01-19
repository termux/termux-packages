TERMUX_PKG_HOMEPAGE=https://tdb.samba.org/
TERMUX_PKG_DESCRIPTION="A trivial database system"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.8
TERMUX_PKG_SRCURL=https://samba.org/ftp/tdb/tdb-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8434c9c857d13ce3fa8466f75601f25c3693676b36919f159e0ad6121baf5ce8
TERMUX_PKG_DEPENDS="libbsd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cross-compile
--cross-answers cross-answers.txt
--disable-python
"

termux_step_pre_configure() {
	sed 's:@TERMUX_ARCH@:'$TERMUX_ARCH':g' \
		$TERMUX_PKG_BUILDER_DIR/cross-answers.txt > cross-answers.txt
}

termux_step_configure() {
	./configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
