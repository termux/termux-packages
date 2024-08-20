TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Poppler Qt wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `poppler` package.
TERMUX_PKG_VERSION="24.05.0"
# Do not forget to bump revision of reverse dependencies and rebuild them
# when SOVERSION is changed.
_POPPLER_SOVERSION=137
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d8c5eb30b50285ad9f0af8c6335cc2d3b9597fca475cbc2598a5479fa379f779
# The package must be updated at the same time as poppler, auto updater script does not support that.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="freetype, libc++, littlecms, poppler (>= ${TERMUX_PKG_VERSION}), qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_GOBJECT_INTROSPECTION=OFF
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=ON
-DENABLE_QT6=OFF
-DFONT_CONFIGURATION=fontconfig
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	if ! test "${_POPPLER_SOVERSION}"; then
		termux_error_exit "Please set _POPPLER_SOVERSION variable."
	fi
	local sover_main=$(. $TERMUX_SCRIPTDIR/packages/poppler/build.sh; echo $_POPPLER_SOVERSION)
	if [ "${sover_main}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION mismatch with \"poppler\" package."
	fi
	local sover_cmake=$(sed -En 's/^set\(POPPLER_SOVERSION_NUMBER "([0-9]+)"\)$/\1/p' CMakeLists.txt)
	if [ "${sover_cmake}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed (CMakeLists.txt: \"${sover_cmake}\")."
	fi

	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}

termux_step_make_install() {
	cmake --build "${TERMUX_PKG_BUILDDIR}" --target qt5/install
	install -Dm600 -t "${TERMUX_PREFIX}"/lib/pkgconfig "${TERMUX_PKG_BUILDDIR}"/poppler-qt5.pc
}
