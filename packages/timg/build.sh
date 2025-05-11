TERMUX_PKG_HOMEPAGE=https://timg.sh/
TERMUX_PKG_DESCRIPTION="A terminal image and video viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.2"
TERMUX_PKG_SRCURL=https://github.com/hzeller/timg/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5fb4443f55552d15a8b22b9ca4cb5874eb1a988d3b98fe31d61d19b2c7b9e56
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, graphicsmagick, libc++, libcairo, libdeflate, libjpeg-turbo, libexif, librsvg, libsixel, poppler, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_VIDEO_DECODING=on
-DWITH_OPENSLIDE_SUPPORT=off
-DWITH_GRAPHICSMAGICK=on
-DWITH_TURBOJPEG=on
-DWITH_STB_IMAGE=off
-DWITH_POPPLER=on
-DWITH_LIBSIXEL=on
-DWITH_RSVG=on
"

termux_step_pre_configure() {
	# error: non-constant-expression cannot be narrowed from type 'int64_t' to 'time_t' in initializer list [-Wc++11-narrowing]
	CXXFLAGS+=" -Wno-c++11-narrowing"
}
