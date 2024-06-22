TERMUX_PKG_HOMEPAGE=https://pagure.io/newt
TERMUX_PKG_DESCRIPTION="A programming library for color text mode, widget based user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.52.24"
TERMUX_PKG_SRCURL=https://releases.pagure.org/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ded7e221f85f642521c49b1826c8de19845aa372baf5d630a51774b544fbdbb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, slang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
--without-python
--without-tcl
"
