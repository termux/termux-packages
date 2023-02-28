TERMUX_PKG_HOMEPAGE=https://duckdb.org/
TERMUX_PKG_DESCRIPTION="An in-process SQL OLAP database management system"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.1
# we clone to retain the .git directory, to ensure the version in the built executable is correctly populated
TERMUX_PKG_SRCURL=git+https://github.com/duckdb/duckdb
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
	CXXFLAGS+=" -D_GLIBCXX_USE_CXX11_ABI=1"
}
