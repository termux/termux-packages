TERMUX_PKG_HOMEPAGE="https://milkytracker.github.io"
TERMUX_PKG_DESCRIPTION="music creation tool inspired by Fast Tracker 2"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.06"
TERMUX_PKG_SRCURL="https://github.com/milkytracker/MilkyTracker/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6e70590dfed324e6d6ac813e33d9f9dcfaa13b2f57fdec9e178e9dda05538cb0
TERMUX_PKG_DEPENDS="libc++, sdl2 | sdl2-compat, zlib"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-c++11-narrowing"
}
