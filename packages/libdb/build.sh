TERMUX_PKG_HOMEPAGE=https://www.oracle.com/database/berkeley-db
TERMUX_PKG_DESCRIPTION="The Berkeley DB embedded database system (library)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=18.1.32
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=fa1fe7de9ba91ad472c25d026f931802597c29f28ae951960685cde487c8d654
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/db-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-hash
--enable-smallbuild
--enable-compat185
db_cv_atomic=gcc-builtin
--enable-cxx
"
TERMUX_PKG_RM_AFTER_INSTALL="docs"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/dist
}
