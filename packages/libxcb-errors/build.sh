TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/xorg/lib/libxcb-errors
TERMUX_PKG_DESCRIPTION="XCB utility library that gives human readable names to error, event, & request codes."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.1"
TERMUX_PKG_GIT_BRANCH="xcb-util-errors-${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL=git+https://gitlab.freedesktop.org/xorg/lib/libxcb-errors
TERMUX_PKG_BUILD_DEPENDS="libxcb, xcb-proto"

termux_step_pre_configure() {
	autoreconf -fi
}
