TERMUX_PKG_HOMEPAGE=https://github.com/jeaye/stdman
TERMUX_PKG_DESCRIPTION="Formatted C++23 stdlib man pages (cppreference)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2024.07.05
TERMUX_PKG_SRCURL=https://github.com/jeaye/stdman/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3cd652cb76c4fc7604c2b961a726788550c01065032bcff0a706b44f2eb0f75a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="mandoc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Just install manpages without building generation utility.
	:
}
