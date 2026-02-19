TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="PDF rendering library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `poppler-qt` package.
TERMUX_PKG_VERSION="26.02.0"
TERMUX_PKG_SRCURL="https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=dded8621f7b2f695c91063aab1558691c8418374cd583501e89ed39487e7ab77
# The package must be updated at the same time as poppler, auto updater script does not support that.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, gpgme, gpgmepp, libc++, libcairo, libcurl, libiconv, libjpeg-turbo, libnspr, libnss, libpng, libtiff, littlecms, openjpeg, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, g-ir-scanner, openjpeg-tools"
TERMUX_PKG_BREAKS="poppler-dev, poppler-qt (<< ${TERMUX_PKG_VERSION})"
TERMUX_PKG_REPLACES="poppler-dev, poppler-qt (<< 22.04.0-3)"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_GOBJECT_INTROSPECTION=ON
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=OFF
-DENABLE_QT6=OFF
-DFONT_CONFIGURATION=fontconfig
"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# when SOVERSION is changed.
	local _POPPLER_SOVERSION=157
	if ! test "${_POPPLER_SOVERSION}"; then
		termux_error_exit "Please set _POPPLER_SOVERSION variable."
	fi
	local sover_x11=$(. $TERMUX_SCRIPTDIR/x11-packages/poppler-qt/build.sh; echo $_POPPLER_SOVERSION)
	if [ "${sover_x11}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION mismatch with \"poppler-qt\" package."
	fi
	local sover_cmake=$(sed -En 's/^set\(POPPLER_SOVERSION_NUMBER "([0-9]+)"\)$/\1/p' CMakeLists.txt)
	if [ "${sover_cmake}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed (CMakeLists.txt: \"${sover_cmake}\")."
	fi

	termux_setup_gir

	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}
