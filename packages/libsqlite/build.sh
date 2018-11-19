TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=25
_SQLITE_PATCH=3
TERMUX_PKG_SHA256=00ebf97be13928941940cc71de3d67e9f852698233cd98ce2d178fd08092f3dd
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
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
	LDFLAGS+=" -lm"
}

termux_step_post_make_install () {
	mkdir -p $TERMUX_PREFIX/src/libsqlite
	cp $TERMUX_PKG_SRCDIR/tea/generic/tclsqlite3.c $TERMUX_PREFIX/src/libsqlite/tclsqlite3.c
}
