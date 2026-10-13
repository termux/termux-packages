TERMUX_PKG_HOMEPAGE=https://www.mltframework.org/
TERMUX_PKG_DESCRIPTION="Multimedia Framework. Author, manage, and run multitrack audio/video compositions."
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION="7.42.0"
TERMUX_PKG_SRCURL=https://github.com/mltframework/mlt/releases/download/v${TERMUX_PKG_VERSION}/mlt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8800e343f43aaa885bd5d9d23553030fa220aa3e2f0c94d9fd6a936d41638cdd
TERMUX_PKG_DEPENDS="alsa-lib, ffmpeg, fftw, fontconfig, frei0r-plugins, gdk-pixbuf, glib, jack, movit, libebur128, libepoxy, libexif, librnnoise, libsamplerate, libvidstab, libvorbis, libx11, libxml2, lilv, qt6-qt5compat, qt6-qtbase, qt6-qtsvg, opengl, pango, python, rubberband, sdl, sdl2 | sdl2-compat, sox, zlib"
TERMUX_PKG_BUILD_DEPENDS="ladspa-sdk, libarchive, swig"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_SUGGESTS="$TERMUX_PKG_BUILD_DEPENDS"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DMOD_GLAXNIMATE_QT6=ON
-DMOD_QT6=ON
-DSWIG_PYTHON=ON
"

termux_step_pre_configure() {
	termux_setup_python_pip

	# We don't get python in path until termux_setup_python_pip is called in
	# termux_step_get_dependencies_python
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DPython3_EXECUTABLE=$(command -v python)
	"

	# Fix linker script error
	LDFLAGS+=" -Wl,--undefined-version"

	# Link openmp library statically
	LDFLAGS+=" -fopenmp -static-openmp"
}
