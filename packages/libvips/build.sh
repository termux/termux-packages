TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.18.7"
TERMUX_PKG_SRCURL="https://github.com/libvips/libvips/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5024b4b36f20e722c267f4a9bfbdbbafb3b37d48d7125cf425c55bbf76cc9286
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cfitsio, cgif, fftw, fontconfig, glib, highway, imagemagick, imath, libc++, libcairo, libexif, libexpat, libheif, libimagequant, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openexr, openjpeg, pango, poppler, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dvapi=true
-Dorc=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=42
	if [ ! -e "lib/libvips.so.${_SOVERSION}" ]; then
		echo "ERROR: Expected: lib/libvips.so.${_SOVERSION}" 1>&2
		echo "ERROR: Found   : $(find lib/libvips* -regex '.*so\.[0-9]+')" 1>&2
		termux_error_exit "Not proceeding with update."
	fi
}
