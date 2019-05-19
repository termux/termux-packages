TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.49.15
_COMMIT=91676e939e1198fa536a0cdefbcd9331c70efc4c
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=94cbb124219f11664639492114eb65185b6f0ffe04f505609f6784842e718554
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk2, libandroid-glob, libandroid-shmem, libcairo-x, libjpeg-turbo, littlecms, pango-x, libpng, libtiff, libx11, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=${TERMUX_PREFIX}/share/man man GIF jpeg tiff cflags lcms2"

termux_step_pre_configure() {
	export LDFLAGS="${LDFLAGS} -landroid-glob -landroid-shmem"
}
