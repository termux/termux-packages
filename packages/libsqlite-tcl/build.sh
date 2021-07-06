TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="tcl bindings for SQLite"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# Note: Updating this version requires bumping libsqlite package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=35
_SQLITE_PATCH=5
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/2021/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_SHA256=f52b72a5c319c3e516ed7a92e123139a6e87af08a2dc43d7757724f6132e6db0
TERMUX_PKG_DEPENDS="libsqlite, tcl"
TERMUX_PKG_BREAKS="sqlcipher (<< 4.4.2-1), tcl (<< 8.6.10-4)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tcl=${TERMUX_PREFIX}/lib
--with-system-sqlite
"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/tea"
}
