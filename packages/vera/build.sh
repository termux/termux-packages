TERMUX_PKG_HOMEPAGE=https://bitbucket.org/verateam/vera
TERMUX_PKG_DESCRIPTION="A programmable tool for verification, analysis and transformation of C++ source code"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/verateam/vera/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32d1d29be8ec96556fa0935d908d2627daffbf117abd1aa639f5a1c64ae10ceb
TERMUX_PKG_DEPENDS="boost, libc++, tcl"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DVERA_LUA=OFF
-DVERA_PYTHON=OFF
-DVERA_USE_SYSTEM_BOOST=ON
"

termux_step_post_configure() {
	if [ "$TERMUX_CMAKE_BUILD" = "Ninja" ]; then
		sed -i 's:[^ ]*/src/vera++ :true :g' build.ninja
	fi
}
