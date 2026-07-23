TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.52.5"
TERMUX_PKG_SRCURL="https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8a531a9abd2215936e8a8a914c077b586c0228b31d652f205286a8ec90f3364b
TERMUX_PKG_DEPENDS="atk, enchant, fontconfig, freetype, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, harfbuzz, harfbuzz-icu, libavif, libc++, libcairo, libdrm, libgcrypt, libhyphen, libicu, libjpeg-turbo, libpng, libsoup3, libtasn1, libwebp, libxml2, libx11, libxcomposite, libxdamage, libxslt, libxt, littlecms, openjpeg, pango, woff2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_DEBUG_BUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BUBBLEWRAP_SANDBOX=OFF
-DENABLE_DOCUMENTATION=OFF
-DENABLE_DRAG_SUPPORT=ON
-DENABLE_GAMEPAD=OFF
-DENABLE_INTROSPECTION=ON
-DENABLE_JOURNALD_LOG=OFF
-DENABLE_MINIBROWSER=ON
-DENABLE_PDFJS=ON
-DENABLE_QUARTZ_TARGET=OFF
-DENABLE_SPEECH_SYNTHESIS=OFF
-DENABLE_SPELLCHECK=ON
-DENABLE_TOUCH_EVENTS=ON
-DENABLE_USER_MESSAGE_HANDLERS=ON
-DENABLE_VIDEO=ON
-DENABLE_WAYLAND_TARGET=OFF
-DENABLE_WEB_AUDIO=ON
-DENABLE_WEBDRIVER=ON
-DENABLE_X11_TARGET=ON
-DPORT=GTK
-DUSE_AVIF=ON
-DUSE_FLITE=OFF
-DUSE_GBM=OFF
-DUSE_GSTREAMER_GL=OFF
-DUSE_GSTREAMER_WEBRTC=OFF
-DUSE_GSTREAMER=ON
-DUSE_GTK4=OFF
-DUSE_JPEGXL=ON
-DUSE_LCMS=ON
-DUSE_LIBBACKTRACE=OFF
-DUSE_LIBDRM=ON
-DUSE_LIBHYPHEN=ON
-DUSE_LIBSECRET=OFF
-DUSE_SKIA_OPENTYPE_SVG=ON
-DUSE_SYSTEM_MALLOC=ON
-DUSE_SYSTEM_SYSPROF_CAPTURE=OFF
-DUSE_WOFF2=OFF
"

termux_step_post_get_source() {
	# Version guard
	local ver_e=${TERMUX_PKG_VERSION#*:}
	local ver_x=$(. $TERMUX_SCRIPTDIR/x11-packages/webkitgtk-6.0/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between webkit2gtk-4.1 and webkitgtk-6.0."
	fi
}

termux_step_pre_configure() {
	termux_setup_gir

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		export CXXFLAGS+=" -Wno-missing-template-arg-list-after-template-kw"
	fi

	# Workaround for https://github.com/android/ndk/issues/1973
	[ "$TERMUX_ARCH" == "arm" ] && sed -i '/#define MUST_TAIL_CALL \[\[clang::musttail]]/d' Source/WTF/wtf/Compiler.h

	CPPFLAGS+=" -DHAVE_MISSING_STD_FILESYSTEM_PATH_CONSTRUCTOR"
	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/lib/gstreamer-1.0/include"
	export PATH="${TERMUX_SCRIPTDIR}/scripts/bin:$PATH" # for ldd
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/lib${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
