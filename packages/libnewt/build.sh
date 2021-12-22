TERMUX_PKG_HOMEPAGE=https://pagure.io/newt
TERMUX_PKG_DESCRIPTION="A programming library for color text mode, widget based user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.52.21
TERMUX_PKG_SRCURL=https://releases.pagure.org/newt/newt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=265eb46b55d7eaeb887fca7a1d51fe115658882dfe148164b6c49fccac5abb31
TERMUX_PKG_DEPENDS="libandroid-support, libpopt, slang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
--without-python
--without-tcl
"
