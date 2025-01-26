TERMUX_PKG_HOMEPAGE=https://www.ferzkopp.net/joomla/content/view/19/14/
TERMUX_PKG_DESCRIPTION="Graphics primitives and surface functions for SDL2"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262
TERMUX_PKG_DEPENDS="sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-mmx
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
