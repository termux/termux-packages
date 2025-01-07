TERMUX_PKG_HOMEPAGE=https://www.mltframework.org/
TERMUX_PKG_DESCRIPTION="Multimedia Framework. Author, manage, and run multitrack audio/video compositions."
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION="7.28.0"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/mltframework/mlt/releases/download/v${TERMUX_PKG_VERSION}/mlt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bc425bf9602213f5f4855b78cfbbcd43eeb78097c508588bde44415963955aa1
TERMUX_PKG_DEPENDS="alsa-lib, ffmpeg, fftw, fontconfig, frei0r-plugins, gdk-pixbuf, glib, jack, movit, libebur128, libepoxy, libexif, libsamplerate, libvidstab, libvorbis, libx11, libxml2, qt6-qt5compat, qt6-qtbase, qt6-qtsvg, opengl, pango, python, rubberband, sdl, sdl2, sox, zlib"
TERMUX_PKG_BUILD_DEPENDS="ladspa-sdk, libarchive, swig"
TERMUX_PKG_SUGGESTS="$TERMUX_PKG_BUILD_DEPENDS"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMOD_GLAXNIMATE=ON
-DMOD_GLAXNIMATE_QT6=ON
-DMOD_QT6=ON
-DSWIG_PYTHON=ON
"

termux_step_pre_configure() {
	# Fix linker script error
	LDFLAGS+=" -Wl,--undefined-version"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		patch --silent -p1 -d "$TERMUX_PKG_SRCDIR" < "$TERMUX_PKG_BUILDER_DIR/32-bit-symbol.diff"
	fi
}
