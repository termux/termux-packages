TERMUX_PKG_HOMEPAGE=https://github.com/xiph/vorbis-tools
TERMUX_PKG_DESCRIPTION="Ogg Vorbis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/vorbis/vorbis-tools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0
# libflac for flac support in oggenc:
TERMUX_PKG_DEPENDS="libiconv, libvorbis, libflac, libogg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ogg123
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
