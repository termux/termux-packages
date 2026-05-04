TERMUX_PKG_HOMEPAGE=https://www.sfml-dev.org/
TERMUX_PKG_DESCRIPTION="A simple, fast, cross-platform and object-oriented multimedia API"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL=https://github.com/SFML/SFML/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=91209a112c2bd0bc6f4ce0d5f3e413cfb48b57c0de59f5507dc81f71b1ad7a5c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, libflac, libogg, libresolv-wrapper, libssh2, libvorbis, libx11, libxcursor, libxi, libxrandr, mbedtls, openal-soft, opengl"
# -DBUILD_SHARED_LIBS=ON is required to prevent this error when importing SFML using CMake:
# Requested SFML configuration (Shared) was not found
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DSFML_USE_SYSTEM_DEPS=ON
"

termux_step_post_get_source() {
	cp src/SFML/Window/Android/JoystickImpl.{cpp,hpp} src/SFML/Window/Unix/
}
