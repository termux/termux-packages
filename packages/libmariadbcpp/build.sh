TERMUX_PKG_HOMEPAGE=https://mariadb.com/docs/clients/mariadb-connectors/connector-cpp/
TERMUX_PKG_DESCRIPTION="Enables C++ applications to establish client connections to MariaDB Enterprise over TLS"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=git+https://github.com/mariadb-corporation/mariadb-connector-cpp
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libc++, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DINSTALL_LIB_SUFFIX=lib
-DINSTALL_LIBDIR=lib/mariadbcpp
-DINSTALL_PLUGINDIR=lib/mariadbcpp/plugin
-DWITH_EXTERNAL_ZLIB=ON
"

termux_step_pre_configure() {
	LDFLAGS="-Wl,-rpath=$TERMUX_PREFIX/lib/mariadbcpp $LDFLAGS"
}
