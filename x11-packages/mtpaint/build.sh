TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=f37cf09c02b0ebd81d29c67be9741f54d76a9171
TERMUX_PKG_VERSION="1:3.50.11"
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=8da8887a6a66ef31f3b01534e09dad542aa6c92aad43e47611faa7852ecf9e74
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="atk, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libcairo, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, libx11, littlecms, openjpeg, pango, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=$TERMUX_PREFIX
cflags
gtk3
jpeg
lcms2
man
tiff
"

termux_step_post_get_source() {
	local v=$(sed -En 's/^MT_V="([^"]+)".*/\1/p' configure)
	if [ "${v}" != "${TERMUX_PKG_VERSION#*:}" ]; then
		termux_error_exit "Version string '$TERMUX_PKG_VERSION' does not seem to be correct."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_configure() {
	sh $TERMUX_PKG_SRCDIR/configure ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
