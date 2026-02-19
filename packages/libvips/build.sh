TERMUX_PKG_HOMEPAGE=https://libvips.github.io/libvips/
TERMUX_PKG_DESCRIPTION="A fast image processing library with low memory needs"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.18.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/libvips/libvips/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=33bf7fad3d775389a2bfbae4b391196ffedcfa1f3fed258ec506d9c0241b0612
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cgif, fftw, fontconfig, glib, imagemagick, imath, libc++, libcairo, libexif, libexpat, libheif, libimagequant, libjpeg-turbo, libjxl, libpng, librsvg, libtiff, libwebp, littlecms, openexr, openjpeg, pango, poppler, zlib"
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
