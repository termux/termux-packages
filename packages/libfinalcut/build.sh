TERMUX_PKG_HOMEPAGE=https://github.com/gansm/finalcut
TERMUX_PKG_DESCRIPTION="A C++ class library and widget toolkit for creating a text-based user interface"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/gansm/finalcut/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0bb4de87df2c466d5ba6513cadcb691a3387e60884c65c7bd158e8350f7f4829
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
