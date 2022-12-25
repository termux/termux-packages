TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.50.09
TERMUX_PKG_REVISION=5
_COMMIT=5272e2b1e773c8e02ac3506b2d3bde82ad946b21
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=6ed73fc7ac18499c7e83c8077c85dfc0bf778f0663c051515da408e2fcfea512
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk2, harfbuzz, libandroid-glob, libcairo, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxrandr, libxrender, littlecms, openjpeg, pango, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=${TERMUX_PREFIX}/share/man man GIF jpeg tiff cflags lcms2"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
