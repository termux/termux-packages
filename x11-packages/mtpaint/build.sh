TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.49.27
TERMUX_PKG_REVISION=6
_COMMIT=26751cd0336414e2f16cbe25c9fe2702f34e7b5c
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=57581585914caaf2808a3a6e7398303c996038700ee4e79fa98b58989bef2ae4
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk2, libandroid-glob, libandroid-shmem, libcairo, libjpeg-turbo, littlecms, pango, libpng, libtiff, libwebp, libx11, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=${TERMUX_PREFIX}/share/man man GIF jpeg tiff cflags lcms2"

termux_step_pre_configure() {
	export LDFLAGS="${LDFLAGS} -landroid-glob -landroid-shmem"
}
