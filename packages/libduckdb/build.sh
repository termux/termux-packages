TERMUX_PKG_HOMEPAGE=https://duckdb.org/
TERMUX_PKG_DESCRIPTION="An in-process SQL OLAP database management system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.2
# we clone to retain the .git directory, to ensure the version in the built executable is correctly populated
TERMUX_PKG_SRCURL=https://github.com/duckdb/duckdb.git
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
