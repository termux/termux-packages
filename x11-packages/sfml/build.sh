TERMUX_PKG_HOMEPAGE=https://www.sfml-dev.org/
TERMUX_PKG_DESCRIPTION="A simple, fast, cross-platform and object-oriented multimedia API"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.2"
TERMUX_PKG_SRCURL=https://github.com/SFML/SFML/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15ff4d608a018f287c6a885db0a2da86ea389e516d2323629e4d4407a7ce047f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, libc++, libflac, libogg, libvorbis, libx11, libxcursor, libxrandr, openal-soft, opengl"

termux_step_post_get_source() {
	cp src/SFML/Window/Android/JoystickImpl.{cpp,hpp} src/SFML/Window/Unix/
}
