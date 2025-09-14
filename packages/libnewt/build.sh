TERMUX_PKG_HOMEPAGE=https://pagure.io/newt
TERMUX_PKG_DESCRIPTION="A programming library for color text mode, widget based user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.52.25"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://releases.pagure.org/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef0ca9ee27850d1a5c863bb7ff9aa08096c9ed312ece9087b30f3a426828de82
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, slang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
--without-python
--without-tcl
"
