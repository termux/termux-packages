TERMUX_PKG_HOMEPAGE=https://github.com/cabinpkg/cabin
TERMUX_PKG_DESCRIPTION="A package manager and build system for C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL="https://github.com/cabinpkg/cabin/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0ffefbfa8aa26a55c9acb058943a35a4d316ad13f588fee0c66ee5e16673e657
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="poac"
TERMUX_PKG_REPLACES="poac"
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json"
TERMUX_PKG_DEPENDS="fmt, libc++, libcurl, libgit2, libtbb"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	make RELEASE=1 -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin build/cabin
}
