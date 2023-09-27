TERMUX_PKG_HOMEPAGE=https://github.com/muellan/clipp
TERMUX_PKG_DESCRIPTION="Command line interfaces for modern C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/muellan/clipp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73da8e3d354fececdea99f7deb79d0343647349563ace3eafb7f4cca6e86e90b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/include include/clipp.h
}
