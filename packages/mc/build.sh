TERMUX_PKG_HOMEPAGE=https://midnight-commander.org
TERMUX_PKG_DESCRIPTION="Midnight Commander - a powerful file manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.8.33"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/MidnightCommander/mc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=092e440930fda43574739e45a8b41af384b974e6720184b6707d127b84082c51
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib, libandroid-support, libssh2, ncurses, which"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_util_openpty=no
ac_cv_path_PERL=$TERMUX_PREFIX/bin/perl
ac_cv_path_PERL_FOR_BUILD=/usr/bin/perl
ac_cv_path_PYTHON=$TERMUX_PREFIX/bin/python
ac_cv_path_RUBY=$TERMUX_PREFIX/bin/ruby
ac_cv_path_UNZIP=$TERMUX_PREFIX/bin/unzip
ac_cv_path_ZIP=$TERMUX_PREFIX/bin/zip
--with-ncurses-includes=$TERMUX_PREFIX/include
--with-ncurses-libs=$TERMUX_PREFIX/lib
--with-screen=ncurses
"

termux_step_pre_configure() {
	./autogen.sh
}
