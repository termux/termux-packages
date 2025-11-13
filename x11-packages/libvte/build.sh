TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL3, COPYING.LGPL3, COPYING.XTERM"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.82.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/vte/-/archive/${TERMUX_PKG_VERSION:2}/vte-${TERMUX_PKG_VERSION:2}.tar.bz2
#TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/vte/${_MAJOR_VERSION}/vte-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=8ba2a82c19c96e56fb77560c1caa49ca0a236e65d3b9123465794d863cd2a0d1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, glib, gtk3, gtk4, libc++, libcairo, libgnutls, libicu, liblz4, pango, pcre2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX -Wno-cast-function-type-strict -Wno-deprecated-declarations -Wno-cast-function-type"
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libvte-2.91-gtk4.so.0'
		'lib/libvte-2.91.so.0'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}
