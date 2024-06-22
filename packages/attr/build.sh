TERMUX_PKG_HOMEPAGE=http://savannah.nongnu.org/projects/attr/
TERMUX_PKG_DESCRIPTION="Utilities for manipulating filesystem extended attributes"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.2"
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/attr/attr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=39bf67452fa41d0948c2197601053f48b3d78a029389734332a6309a680c6c87
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="attr-dev"
TERMUX_PKG_REPLACES="attr-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gettext=no"
# TERMUX_PKG_MAKE_INSTALL_TARGET="install install-lib"
# attr.5 man page is in manpages:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man5/attr.5"
