TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=29
_SQLITE_PATCH=0
TERMUX_PKG_SHA256=8e7c1e2950b5b04c5944a981cb31fffbf9d2ddda939d536838ebc854481afd5b
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.sqlite.org/2019/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BREAKS="libsqlite-dev"
TERMUX_PKG_REPLACES="libsqlite-dev"
# ac_cv_func_strerror_r=no as strerror_r() with the
# GNU signature is only # available in android-23:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strerror_r=no
--enable-readline
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	LDFLAGS+=" -lm"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/src/libsqlite
	cp $TERMUX_PKG_SRCDIR/tea/generic/tclsqlite3.c $TERMUX_PREFIX/src/libsqlite/tclsqlite3.c
}
