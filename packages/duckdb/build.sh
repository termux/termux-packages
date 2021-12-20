TERMUX_PKG_HOMEPAGE=https://www.duckdb.org
TERMUX_PKG_DESCRIPTION="DuckDB is an in-process SQL OLAP Database Management System"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.3.1
TERMUX_PKG_SRCURL=https://github.com/duckdb/duckdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ae2367d0a393be59e137ffa975f48f60b113b2a72aacc24fbc59afa0cbc3a511
termux_step_pre_configure() {
	LDFLAGS=" -llog"
}
