# Package disabled - does Android support setting extended file attributes?
# I'm getting 'Operation not supported on transport endpoint' on all tests.
TERMUX_PKG_HOMEPAGE=http://savannah.nongnu.org/projects/attr/
TERMUX_PKG_DESCRIPTION="Commands for manipulating filesystem extended attributes."
TERMUX_PKG_VERSION=2.4.47
TERMUX_PKG_SRCURL=http://download.savannah.gnu.org/releases/attr/attr-${TERMUX_PKG_VERSION}.src.tar.gz
TERMUX_PKG_FOLDERNAME=attr-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gettext=no"
TERMUX_PKG_MAKE_INSTALL_TARGET="install install-lib"
