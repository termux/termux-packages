TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.49.19
TERMUX_PKG_REVISION=5
_COMMIT=a9e445ef0167631363fe954bd3ea7aec7853ca1a
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=f78f53c247eb133a60fd75df8c1caf73d46e8de570afcd7a8e178ba85cb54a92
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk2, libandroid-glob, libandroid-shmem, libcairo, libjpeg-turbo, littlecms, pango, libpng, libtiff, libwebp, libx11, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=${TERMUX_PREFIX}/share/man man GIF jpeg tiff cflags lcms2"

termux_step_pre_configure() {
	export LDFLAGS="${LDFLAGS} -landroid-glob -landroid-shmem"
}
