TERMUX_PKG_HOMEPAGE=https://github.com/jeaye/stdman
TERMUX_PKG_DESCRIPTION="Formatted C++20 stdlib man pages (cppreference)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2020.11.17
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jeaye/stdman/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6e96634c67349e402339b1faa8f99e47f4145aa110e2ad492e00676b28bb05e2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="man"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Just install manpages without building generation utility.
	:
}
