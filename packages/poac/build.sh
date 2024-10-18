TERMUX_PKG_HOMEPAGE=https://github.com/poac-dev/poac
TERMUX_PKG_DESCRIPTION="A package manager and build system for C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/poac-dev/poac/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4be4f9d80ee1b4b2dd489bc335d59b50d945ad2bff9458eba66b230247f5c8a6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json"
TERMUX_PKG_DEPENDS="fmt, libc++, libcurl, libgit2, libtbb"
TERMUX_PKG_SUGGESTS="clang, make, pkg-config"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make() {
	make RELEASE=1 -j$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin build-out/poac
}
