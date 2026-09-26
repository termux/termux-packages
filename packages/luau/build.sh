TERMUX_PKG_HOMEPAGE=https://github.com/luau-lang/luau
TERMUX_PKG_DESCRIPTION="A small, fast, and embeddable programming language based on Lua with a gradual type system."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE.txt
extern/isocline/LICENSE
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.740"
TERMUX_PKG_SRCURL="https://github.com/luau-lang/luau/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=419f96e4ecf5a0dd415a2625ea7ea9dc8a407e86d64b25e00936302b25a7afbd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUAU_BUILD_TESTS=OFF
"

termux_step_pre_configure() {
	export CPPFLAGS+=" -DLUAU_ENABLE_TIME_TRACE"
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" luau luau-*
}
