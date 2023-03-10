TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/glslang
TERMUX_PKG_DESCRIPTION="OpenGL and OpenGL ES shader front end and validator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.13.0
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/glslang/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=592c98aeb03b3e81597ddaf83633c4e63068d14b18a766fd11033bad73127162
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-GNinja
-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX
-DCMAKE_BUILD_TYPE=None
-DBUILD_SHARED_LIBS=ON
-Bbuild-shared
"

termux_step_pre_configure() {
	termux_setup_ninja
	termux_setup_cmake
}

termux_step_make() {
	ninja -Cbuild-shared
}

termux_step_make_install() {
	ninja -C build-shared install
}
