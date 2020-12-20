TERMUX_PKG_HOMEPAGE=https://github.com/xiph/vorbis-tools
TERMUX_PKG_DESCRIPTION="Ogg Vorbis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/vorbis/vorbis-tools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc
# libflac for flac support in oggenc:
TERMUX_PKG_DEPENDS="libiconv, libvorbis, libflac, libogg"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
