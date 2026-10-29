TERMUX_PKG_HOMEPAGE=https://github.com/dirkvdb/ffmpegthumbnailer
TERMUX_PKG_DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.0"
TERMUX_PKG_SRCURL="https://github.com/dirkvdb/ffmpegthumbnailer/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0f2ed039b7f495da217e266a509108e914156ef0e321b49342ebb37b345ccec6
TERMUX_PKG_DEPENDS="ffmpeg, libc++, libjpeg-turbo, libpng"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GIO=ON
-DENABLE_THUMBNAILER=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
