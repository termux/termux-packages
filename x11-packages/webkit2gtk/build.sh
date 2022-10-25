# This specific package is for webkit2gtk-4.0.
TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.38.1
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=02e195b3fb9e057743b3364ee7f1eec13f71614226849544c07c32a73b8f1848
TERMUX_PKG_DEPENDS="atk, enchant, fontconfig, freetype, glib, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, harfbuzz, harfbuzz-icu, libc++, libcairo, libgcrypt, libhyphen, libicu, libjpeg-turbo, libnotify, libpng, libsoup, libtasn1, libwebp, libxml2, libx11, libxcomposite, libxdamage, libxslt, libxt, littlecms, openjpeg, pango, woff2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
#TERMUX_PKG_PROVIDES="webkit2gtk-4.0"
TERMUX_PKG_BREAKS="webkit, webkitgtk"
TERMUX_PKG_REPLACES="webkit, webkitgtk"
TERMUX_PKG_DISABLE_GIR=false

# USE_OPENGL_OR_ES causes crashes when enabled.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPORT=GTK
-DENABLE_GAMEPAD=OFF
-DUSE_SYSTEMD=OFF
-DUSE_LIBSECRET=OFF
-DENABLE_INTROSPECTION=ON
-DENABLE_DOCUMENTATION=OFF
-DUSE_WPE_RENDERER=OFF
-DENABLE_BUBBLEWRAP_SANDBOX=OFF
-DUSE_LD_GOLD=OFF
-DUSE_OPENGL_OR_ES=OFF
-DENABLE_JOURNALD_LOG=OFF
-DUSE_SOUP2=ON
-DUSE_GTK4=OFF
-DENABLE_WEBDRIVER=OFF
"
# WebKitWebDriver is provided by a subpackage of webkit2gtk-4.1 named
# webkit2gtk-driver.
TERMUX_PKG_RM_AFTER_INSTALL="bin/WebKitWebDriver"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -DHAVE_MISSING_STD_FILESYSTEM_PATH_CONSTRUCTOR"
	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/lib${TERMUX_PKG_NAME}-4.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
