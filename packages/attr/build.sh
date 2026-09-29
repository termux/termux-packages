TERMUX_PKG_HOMEPAGE=http://savannah.nongnu.org/projects/attr/
TERMUX_PKG_DESCRIPTION="Utilities for manipulating filesystem extended attributes"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.0"
TERMUX_PKG_SRCURL="http://download.savannah.gnu.org/releases/attr/attr-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d42fa374513180bb48cb11a46696f488240e5124ff1e6ad88b0abff706985612
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="attr-dev"
TERMUX_PKG_REPLACES="attr-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gettext=no"
# TERMUX_PKG_MAKE_INSTALL_TARGET="install install-lib"
# attr.5 man page is in manpages:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man5/attr.5"
