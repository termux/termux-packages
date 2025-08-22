TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=7cae5d663ed835a365d89a535536c39e18862a83
TERMUX_PKG_VERSION="1:3.50.12"
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=12d861af3e6db4167390bbcf1fd1b79960753acd6ec049bc6cd0d9898c137e89
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
