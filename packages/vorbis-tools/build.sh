TERMUX_PKG_HOMEPAGE=https://github.com/xiph/vorbis-tools
TERMUX_PKG_DESCRIPTION="Ogg Vorbis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.3"
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/vorbis/vorbis-tools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a1fe3ddc6777bdcebf6b797e7edfe0437954b24756ffcc8c6b816b63e0460dde
TERMUX_PKG_AUTO_UPDATE=true
# libflac for flac support in oggenc:
TERMUX_PKG_DEPENDS="libiconv, libvorbis, libflac, libogg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ogg123
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
