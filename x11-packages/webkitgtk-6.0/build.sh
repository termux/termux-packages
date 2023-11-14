TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.40.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cc0aa83f40dbc64c1c6ae42ec6b85af4be2a9dbf524cfcb95f89a367fb5098dd
TERMUX_PKG_DEPENDS="enchant, fontconfig, freetype, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk4, harfbuzz, harfbuzz-icu, libc++, libcairo, libgcrypt, libhyphen, libicu, libjpeg-turbo, libpng, libsoup3, libtasn1, libwebp, libxml2, libx11, libxcomposite, libxdamage, libxslt, libxt, littlecms, openjpeg, pango, woff2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_DISABLE_GIR=false

termux_step_post_get_source() {
	local p
	for p in $TERMUX_SCRIPTDIR/x11-packages/webkit2gtk-4.1/*.patch; do
		echo "Applying $(basename "${p}")"
		sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" "${p}" \
			| patch --silent -p1
	done
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=$(
		. $TERMUX_SCRIPTDIR/x11-packages/webkit2gtk-4.1/build.sh
		echo $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	)
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DUSE_GTK4=ON
		-DENABLE_WEBDRIVER=OFF
	"

	termux_setup_gir

	CPPFLAGS+=" -DHAVE_MISSING_STD_FILESYSTEM_PATH_CONSTRUCTOR"
	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/lib${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
