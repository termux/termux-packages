TERMUX_PKG_HOMEPAGE=https://www.sfml-dev.org/
TERMUX_PKG_DESCRIPTION="A simple, fast, cross-platform and object-oriented multimedia API"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.2"
TERMUX_PKG_SRCURL=https://github.com/SFML/SFML/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0034e05f95509e5d3fb81b1625713e06da7b068f210288ce3fd67106f8f46995
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libc++, libflac, libogg, libvorbis, libx11, libxcursor, libxi, libxrandr, openal-soft, opengl"
# -DBUILD_SHARED_LIBS=ON is required to prevent this error when importing SFML using CMake:
# Requested SFML configuration (Shared) was not found
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DSFML_USE_SYSTEM_DEPS=ON
"

termux_step_post_get_source() {
	cp src/SFML/Window/Android/JoystickImpl.{cpp,hpp} src/SFML/Window/Unix/
}
