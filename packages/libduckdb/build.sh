TERMUX_PKG_HOMEPAGE=https://duckdb.org/
TERMUX_PKG_DESCRIPTION="An in-process SQL OLAP database management system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.2
TERMUX_PKG_SRCURL=https://github.com/duckdb/duckdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=65fa44665a4cd187d08a51e2069da953061a3c7c6bbf06f996704ee3f1953d3c
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
