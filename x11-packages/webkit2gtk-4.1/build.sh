TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.42.4"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=52288b30bda22373442cecb86f9c9a569ad8d4769a1f97b352290ed92a67ed86
TERMUX_PKG_DEPENDS="atk, enchant, fontconfig, freetype, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, harfbuzz, harfbuzz-icu, libc++, libcairo, libgcrypt, libhyphen, libicu, libjpeg-turbo, libpng, libsoup3, libtasn1, libwebp, libxml2, libx11, libxcomposite, libxdamage, libxslt, libxt, littlecms, openjpeg, pango, woff2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false

# USE_OPENGL_OR_ES causes crashes when enabled.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPORT=GTK
-DENABLE_GAMEPAD=OFF
-DUSE_SYSTEMD=OFF
-DUSE_LIBSECRET=OFF
-DENABLE_INTROSPECTION=ON
-DENABLE_DOCUMENTATION=OFF
-DENABLE_WAYLAND_TARGET=OFF
-DUSE_WPE_RENDERER=OFF
-DENABLE_BUBBLEWRAP_SANDBOX=OFF
-DUSE_LD_GOLD=OFF
-DUSE_OPENGL_OR_ES=OFF
-DENABLE_JOURNALD_LOG=OFF
-DUSE_SOUP2=OFF
-DUSE_GTK4=OFF
-DUSE_AVIF=OFF
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
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/lib${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
