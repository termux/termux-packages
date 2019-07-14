TERMUX_PKG_HOMEPAGE=https://www.midnight-commander.org/
TERMUX_PKG_DESCRIPTION="Midnight Commander - a powerful file manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.8.23
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=dd7f7ce74183307b0df25b5c3e60ad3293fd3d3d27d2f37dd7a10efce13dff1c
TERMUX_PKG_SRCURL=http://ftp.midnight-commander.org/mc-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, glib, openssl, libssh2, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_util_openpty=no
ac_cv_path_PERL=$TERMUX_PREFIX/bin/perl
ac_cv_path_PYTHON=$TERMUX_PREFIX/bin/python
ac_cv_path_RUBY=$TERMUX_PREFIX/bin/ruby
ac_cv_path_UNZIP=$TERMUX_PREFIX/bin/unzip
ac_cv_path_ZIP=$TERMUX_PREFIX/bin/zip
--with-ncurses-includes=$TERMUX_PREFIX/include
--with-ncurses-libs=$TERMUX_PREFIX/lib
--with-screen=ncurses
"

termux_step_pre_configure() {
	if [ "$TERMUX_DEBUG" == "true" ]; then
		# Debug build fails with:
		# /home/builder/.termux-build/mc/src/src/filemanager/file.c:2019:37: error: 'umask' called with invalid mode
		# src_mode = umask (-1);
		#		      ^
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
