TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=23
_SQLITE_PATCH=0
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SHA256=b7711a1800a071674c2bf76898ae8584fc6c9643cfe933cfc1bc54361e3a6e49
TERMUX_PKG_SRCURL=https://www.sqlite.org/2018/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
# ac_cv_func_strerror_r=no as strerror_r() with the
# GNU signature is only # available in android-23:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strerror_r=no
--enable-readline
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="src/libsqlite/tclsqlite3.c"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror"
}

termux_step_post_make_install () {
	mkdir -p $TERMUX_PREFIX/src/libsqlite
	cp $TERMUX_PKG_SRCDIR/tea/generic/tclsqlite3.c $TERMUX_PREFIX/src/libsqlite/tclsqlite3.c
}
