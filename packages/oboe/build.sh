TERMUX_PKG_HOMEPAGE=https://github.com/google/oboe
TERMUX_PKG_DESCRIPTION="Oboe is a C++ library that makes it easy to build high-performance audio apps on Android."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL="https://github.com/google/oboe/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=af80c16175aa4602e51f3f4378424a199e5d91476b1cba6cd00299bf1e21881f
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_make_install() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=TRUE"
	termux_step_configure
	termux_step_make
	termux_step_make_install
}
