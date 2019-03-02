TERMUX_PKG_HOMEPAGE=https://www.oracle.com/database/berkeley-db
TERMUX_PKG_DESCRIPTION="The Berkeley DB embedded database system (library)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=6.2.32
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://download.oracle.com/berkeley-db/db-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb
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
