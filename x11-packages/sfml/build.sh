TERMUX_PKG_HOMEPAGE=https://www.sfml-dev.org/
TERMUX_PKG_DESCRIPTION="A simple, fast, cross-platform and object-oriented multimedia API"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_SRCURL=https://github.com/SFML/SFML/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c3f84898ea1db07dc46fa92e85038d8c449e3c8653fe09997383173de96bc06
TERMUX_PKG_DEPENDS="freetype, libc++, libflac, libogg, libvorbis, libx11, libxcursor, libxrandr, openal-soft, opengl"

termux_step_post_get_source() {
	cp src/SFML/Window/Android/JoystickImpl.{cpp,hpp} src/SFML/Window/Unix/

	find tools/pkg-config -name '*.pc.in' | xargs -n 1 \
		sed -i -E 's|^(libdir=)\$\{exec_prefix\}/(@CMAKE_INSTALL_LIBDIR@)$|\1\2|'
}
