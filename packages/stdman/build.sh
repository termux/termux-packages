TERMUX_PKG_HOMEPAGE=https://github.com/jeaye/stdman
TERMUX_PKG_DESCRIPTION="Formatted C++20 stdlib man pages (cppreference)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.07.30
TERMUX_PKG_SRCURL=https://github.com/jeaye/stdman/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=332383e5999e1ac9a6210be8b256608187bb7690a2bff990372e93c2ad4e76ff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="man"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Just install manpages without building generation utility.
	:
}
