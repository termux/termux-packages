TERMUX_PKG_HOMEPAGE=https://duckdb.org/
TERMUX_PKG_DESCRIPTION="An in-process SQL OLAP database management system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.2
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
	# we clone to retain the .git directory, to ensure the version in the built executable is correctly populated
	git clone https://github.com/duckdb/duckdb -b v$TERMUX_PKG_VERSION $TERMUX_PKG_SRCDIR
}

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
