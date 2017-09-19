TERMUX_PKG_HOMEPAGE=http://savannah.nongnu.org/projects/attr/
TERMUX_PKG_DESCRIPTION="Utilities for manipulating filesystem extended attributes"
TERMUX_PKG_VERSION=2.4.47
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/attr/attr-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_SHA256=25772f653ac5b2e3ceeb89df50e4688891e21f723c460636548971652af0a859
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gettext=no"
TERMUX_PKG_MAKE_INSTALL_TARGET="install install-lib"
# attr.5 man page is in linux-man-pages:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man5/attr.5"
