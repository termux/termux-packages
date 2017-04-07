TERMUX_PKG_HOMEPAGE=https://www.oracle.com/database/berkeley-db
TERMUX_PKG_DESCRIPTION="The Berkeley DB embedded database system (library)"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=6.2.23
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://download.oracle.com/berkeley-db/db-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=47612c8991aa9ac2f6be721267c8d3cdccf5ac83105df8e50809daea24e95dc7
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-hash
--enable-smallbuild
--enable-compat185
db_cv_atomic=gcc-builtin
"
TERMUX_PKG_RM_AFTER_INSTALL="docs"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/dist
}
