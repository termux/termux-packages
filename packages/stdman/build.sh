TERMUX_PKG_HOMEPAGE=https://github.com/jeaye/stdman
TERMUX_PKG_DESCRIPTION="Formatted C++20 stdlib man pages (cppreference)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2018.03.11
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jeaye/stdman/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d29e6b34cb5ba9905360cee6adcdf8c49e7f11272521bf2e10b42917486840e8
TERMUX_PKG_DEPENDS="man"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# Just install manpages without building generation utility.
	:
}
