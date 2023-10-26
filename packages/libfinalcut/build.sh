TERMUX_PKG_HOMEPAGE=https://github.com/gansm/finalcut
TERMUX_PKG_DESCRIPTION="A C++ class library and widget toolkit for creating a text-based user interface"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/gansm/finalcut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73ff5016bf6de0a5d3d6e88104668b78a521c34229e7ca0c6a04b5d79ecf666e
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
