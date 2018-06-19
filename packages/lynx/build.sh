TERMUX_PKG_HOMEPAGE=http://lynx.browser.org/
TERMUX_PKG_DESCRIPTION="The text web browser"
TERMUX_PKG_VERSION=2.8.9dev.19
TERMUX_PKG_SHA256=0223706f8310ecb738342c6bc51ebbe1879f2890a56c5e6f099e28289a8a8e9f
TERMUX_PKG_SRCURL=http://invisible-mirror.net/archives/lynx/tarballs/lynx${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="ncurses, openssl, libbz2, libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-screen=ncursesw --enable-widec --enable-scrollbar --enable-nested-tables --enable-htmlized-cfg --with-ssl --with-zlib --with-bzlib --enable-cjk --enable-japanese-utf8 --enable-progressbar --enable-prettysrc --enable-forms-options --enable-8bit-toupper --enable-ascii-ctypes --disable-font-switch"

## set default paths for tools that may be used in runtime by 'lynx' binary
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_BZIP2=${TERMUX_PREFIX}/bin/bzip2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_COMPRESS=${TERMUX_PREFIX}/bin/compress"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_GZIP=${TERMUX_PREFIX}/bin/gzip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_INSTALL=${TERMUX_PREFIX}/bin/install"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_MSGINIT=${TERMUX_PREFIX}/bin/msginit"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_MV=${TERMUX_PREFIX}/bin/mv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_RM=${TERMUX_PREFIX}/bin/rm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_TAR=${TERMUX_PREFIX}/bin/tar"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_TELNET=${TERMUX_PREFIX}/bin/applets/telnet"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_UNCOMPRESS=${TERMUX_PREFIX}/bin/uncompress"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_UNZIP=${TERMUX_PREFIX}/bin/unzip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_UUDECODE=${TERMUX_PREFIX}/bin/uudecode"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_ZCAT=${TERMUX_PREFIX}/bin/zcat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_ZIP=${TERMUX_PREFIX}/bin/zip"

termux_step_pre_configure() {
	CC+=" $LDFLAGS"
	unset LDFLAGS
}

termux_step_make_install () {
	make uninstall
	make install
}
