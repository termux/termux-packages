TERMUX_PKG_HOMEPAGE=https://github.com/PCMan/gtk3-nocsd
TERMUX_PKG_DESCRIPTION="A small module used to disable the client side decoration of Gtk+ 3"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3
TERMUX_PKG_SRCURL=https://github.com/PCMan/gtk3-nocsd/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=779c47d894ee3b6751ddb02b62a76757b77eb81232c4f9335564654817889570
TERMUX_PKG_BUILD_DEPENDS="gobject-introspection, gtk3"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
