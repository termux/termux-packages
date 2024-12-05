TERMUX_PKG_HOMEPAGE=https://github.com/gansm/finalcut
TERMUX_PKG_DESCRIPTION="A C++ class library and widget toolkit for creating a text-based user interface"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=https://github.com/gansm/finalcut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6593b3c43ba1de98e4e0e3a563dbf9316fade71ef85c82e6b6f086184ec69a56
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
