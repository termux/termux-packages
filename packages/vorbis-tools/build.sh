TERMUX_PKG_HOMEPAGE=http://www.vorbis.com
TERMUX_PKG_DESCRIPTION="Ogg Vorbis tools"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/vorbis/vorbis-tools-${TERMUX_PKG_VERSION}.tar.gz
# libflac for flac support in oggenc:
TERMUX_PKG_DEPENDS="libvorbis, libflac"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
