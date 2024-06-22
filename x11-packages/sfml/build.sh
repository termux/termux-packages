TERMUX_PKG_HOMEPAGE=https://www.sfml-dev.org/
TERMUX_PKG_DESCRIPTION="A simple, fast, cross-platform and object-oriented multimedia API"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.1"
TERMUX_PKG_SRCURL=https://github.com/SFML/SFML/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82535db9e57105d4f3a8aedabd138631defaedc593cab589c924b7d7a11ffb9d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libc++, libflac, libogg, libvorbis, libx11, libxcursor, libxrandr, openal-soft, opengl"

termux_step_post_get_source() {
	cp src/SFML/Window/Android/JoystickImpl.{cpp,hpp} src/SFML/Window/Unix/

	find tools/pkg-config -name '*.pc.in' | xargs -n 1 \
		sed -i -E 's|^(libdir=)\$\{exec_prefix\}/(@CMAKE_INSTALL_LIBDIR@)$|\1\2|'
}
