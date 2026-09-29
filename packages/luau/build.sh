TERMUX_PKG_HOMEPAGE=https://github.com/luau-lang/luau
TERMUX_PKG_DESCRIPTION="A small, fast, and embeddable programming language based on Lua with a gradual type system."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE.txt
extern/isocline/LICENSE
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.741"
TERMUX_PKG_SRCURL="https://github.com/luau-lang/luau/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=deee653d0f5971b809ef67f50dbe8109ad369d7575e344cfe2013774fed2f4c6
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
