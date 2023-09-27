TERMUX_PKG_HOMEPAGE=https://pagure.io/newt
TERMUX_PKG_DESCRIPTION="A programming library for color text mode, widget based user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.52.23
TERMUX_PKG_SRCURL=https://releases.pagure.org/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=caa372907b14ececfe298f0d512a62f41d33b290610244a58aed07bbc5ada12a
TERMUX_PKG_DEPENDS="libandroid-support, slang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
--without-python
--without-tcl
"
