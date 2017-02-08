TERMUX_PKG_HOMEPAGE=http://www.newsbeuter.org
TERMUX_PKG_DESCRIPTION="An open-source RSS/Atom feed reader for text terminals"
TERMUX_PKG_VERSION=2.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.newsbeuter.org/downloads/newsbeuter-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=74a8bf019b09c3b270ba95adc29f2bbe48ea1f55cc0634276b21fcce1f043dc8
TERMUX_PKG_FOLDERNAME=newsbeuter-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libandroid-support, json-c, libsqlite, libcurl, libxml2, stfl, ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/locale"

termux_step_pre_configure () {
	# Put a temporary link for libtinfo.so
	ln -s -f $TERMUX_PREFIX/lib/libncursesw.so $TERMUX_PREFIX/lib/libtinfo.so
}

termux_step_configure () {
	# nwesbeuter doesn't contain configure script
	return
}

termux_step_post_make_install () {
	rm $TERMUX_PREFIX/lib/libtinfo.so
}
