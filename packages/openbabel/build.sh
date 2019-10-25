TERMUX_PKG_HOMEPAGE=http://openbabel.org/wiki/Main_Page
TERMUX_PKG_DESCRIPTION="Open Babel is a chemical toolbox designed to speak the many languages of chemical data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://github.com/openbabel/openbabel/archive/openbabel-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=5c630c4145abae9bb4ab6c56a940985acb6dadf3a8c3a8073d750512c0220f30
TERMUX_PKG_DEPENDS="libc++, libcairo, libxml2, eigen, boost"
TERMUX_PKG_BREAKS="openbabel-dev"
TERMUX_PKG_REPLACES="openbabel-dev"
# MAEPARSER gives an error related to boost's unit_test_framework during configure
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_MAEPARSER=off"
