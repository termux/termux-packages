TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# Note: Updating this version requires bumping libsqlite-tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=40
_SQLITE_PATCH=1
_SQLITE_YEAR=2022
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_SHA256=2c5dea207fa508d765af1ef620b637dcb06572afa6f01f0815bd5bbf864b33d9
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BREAKS="libsqlite-dev"
TERMUX_PKG_REPLACES="libsqlite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-readline
--enable-fts3
"

termux_step_post_get_source() {
	# Version guard
	local ver_s=${TERMUX_PKG_VERSION#*:}
	local ver_t=$(. $TERMUX_SCRIPTDIR/packages/libsqlite-tcl/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_s}" != "${ver_t}" ]; then
		termux_error_exit "Version mismatch between libsqlite and libsqlite-tcl."
	fi
}

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	LDFLAGS+=" -lm"
}
