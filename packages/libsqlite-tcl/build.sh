TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="tcl bindings for SQLite"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# Note: Updating this version requires bumping libsqlite package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=41
_SQLITE_PATCH=0
_SQLITE_YEAR=2023
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_SHA256=49f77ac53fd9aa5d7395f2499cb816410e5621984a121b858ccca05310b05c70
TERMUX_PKG_DEPENDS="libsqlite, tcl"
TERMUX_PKG_BREAKS="sqlcipher (<< 4.4.2-1), tcl (<< 8.6.10-4)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tcl=${TERMUX_PREFIX}/lib
--with-system-sqlite
"

termux_step_post_get_source() {
	# Version guard
	local ver_s=$(. $TERMUX_SCRIPTDIR/packages/libsqlite/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	local ver_t=${TERMUX_PKG_VERSION#*:}
	if [ "${ver_s}" != "${ver_t}" ]; then
		termux_error_exit "Version mismatch between libsqlite and libsqlite-tcl."
	fi
}

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/tea"
}
