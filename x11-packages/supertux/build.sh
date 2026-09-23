TERMUX_PKG_HOMEPAGE=https://www.supertux.org
TERMUX_PKG_DESCRIPTION="Classic 2D jump'n'run sidescroller game in a style similar to Super Mario Bros"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL="https://github.com/SuperTux/supertux/releases/download/v${TERMUX_PKG_VERSION}/SuperTux-v${TERMUX_PKG_VERSION}-Source.tar.gz"
TERMUX_PKG_SHA256=32fc5b99b9994ed58e58341d6f21de925764b381256e108591136de53bc31da5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="glm"
TERMUX_PKG_DEPENDS="fmt, freetype, glew, libandroid-execinfo, libandroid-spawn, libandroid-stub, libcurl, libogg, libphysfs, libpng, libvorbis, openal-soft, sdl2, sdl2-image, supertux-data, xdg-utils, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_GROUPS="games"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DIS_SUPERTUX_RELEASE=true
-DINSTALL_SUBDIR_BIN=bin
-DINSTALL_SUBDIR_DOC=share/doc/supertux
-DUSE_STATIC_SIMPLESQUIRREL=ON
-DSSQ_BUILD_INSTALL=OFF
-DSQ_DISABLE_INSTALLER=ON
-DENABLE_DISCORD=OFF
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/supertux/LICENSE.txt
"

termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-execinfo -landroid-spawn -llog"
}
