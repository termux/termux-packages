TERMUX_PKG_HOMEPAGE=https://github.com/cabinpkg/cabin
TERMUX_PKG_DESCRIPTION="A package manager and build system for C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.1"
TERMUX_PKG_SRCURL="https://github.com/cabinpkg/cabin/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a8e038452b28880a464885dcbfe515441e0a066e673d3cce5df46871ad4fa38f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="poac"
TERMUX_PKG_REPLACES="poac"
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json"
TERMUX_PKG_DEPENDS="fmt, libc++, libcurl, libgit2, libspdlog, libtbb"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_make() {
	make RELEASE=1 -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin build/cabin
}
