TERMUX_PKG_HOMEPAGE=http://www.jemarch.net/poke.html
TERMUX_PKG_DESCRIPTION="Interactive, extensible editor for binary data."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/poke/poke-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ba7863034a1b08004b0ee8f88bda94160707e9a781d5556f555b507583cf0f1b
TERMUX_PKG_DEPENDS="readline, gettext, json-c, libgc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-sysroot=$(dirname $TERMUX_PREFIX) --disable-threads --disable-hserver"
