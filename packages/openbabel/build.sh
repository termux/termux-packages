TERMUX_PKG_HOMEPAGE=http://openbabel.org/wiki/Main_Page
TERMUX_PKG_DESCRIPTION="Open Babel is a chemical toolbox designed to speak the many languages of chemical data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/openbabel/openbabel/archive/openbabel-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02
TERMUX_PKG_DEPENDS="libc++, libcairo, libxml2, eigen, boost"
TERMUX_PKG_BREAKS="openbabel-dev"
TERMUX_PKG_REPLACES="openbabel-dev"
TERMUX_PKG_GROUPS="science"
# MAEPARSER gives an error related to boost's unit_test_framework during configure
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_MAEPARSER=off -DWITH_COORDGEN=off"
