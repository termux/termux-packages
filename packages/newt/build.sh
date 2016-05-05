TERMUX_PKG_HOMEPAGE=https://fedorahosted.org/newt/
TERMUX_PKG_DESCRIPTION="Newt is a programming library for color text mode, widget based user interfaces"
TERMUX_PKG_VERSION=0.52.19
TERMUX_PKG_BUILD_REVISION=0
TERMUX_PKG_SRCURL=https://fedorahosted.org/releases/n/e/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libpopt, slang"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-tcl --without-python"
TERMUX_PKG_BUILD_IN_SRC=yes