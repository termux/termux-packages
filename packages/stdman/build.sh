TERMUX_PKG_HOMEPAGE=https://github.com/jeaye/stdman
TERMUX_PKG_DESCRIPTION="Formatted C++23 stdlib man pages (cppreference)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2026.11.13
TERMUX_PKG_SRCURL=https://github.com/jeaye/stdman/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=deb29cc1df1ff34618f2cd4b222295db68428c462d7526aed92bd13400019740
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="mandoc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Just install manpages without building generation utility.
	:
}
