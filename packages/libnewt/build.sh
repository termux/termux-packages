TERMUX_PKG_HOMEPAGE=https://pagure.io/newt
TERMUX_PKG_DESCRIPTION="A programming library for color text mode, widget based user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.52.22
TERMUX_PKG_SRCURL=https://releases.pagure.org/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a15efa37e86610b68a942b19a138b44ccb501c234e4c82dab2f5a9b19f7c9e79
TERMUX_PKG_DEPENDS="libandroid-support, slang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
--without-python
--without-tcl
"
