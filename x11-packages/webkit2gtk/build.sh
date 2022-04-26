TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.34.6
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6bc8fd034aad0432a2459ce4fc7ee25ad65a4924c618bf8d93b52b0c1a84c1f6
TERMUX_PKG_DEPENDS="atk, enchant, fontconfig, freetype, glib, gst-plugins-base, gstreamer, gtk3, harfbuzz, harfbuzz-icu, libc++, libcairo, libgcrypt, libhyphen, libicu, libjpeg-turbo, libnotify, libpng, libsoup, libtasn1, libwebp, libxml2, libx11, libxcomposite, libxdamage, libxslt, libxt, openjpeg, pango, woff2"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_RECOMMENDS="glib-networking"
TERMUX_PKG_BREAKS="webkit, webkitgtk"
TERMUX_PKG_REPLACES="webkit, webkitgtk"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPORT=GTK
-DENABLE_GAMEPAD=OFF
-DUSE_SYSTEMD=OFF
-DUSE_LIBSECRET=OFF
-DENABLE_INTROSPECTION=OFF
-DUSE_WPE_RENDERER=OFF
-DENABLE_BUBBLEWRAP_SANDBOX=OFF
-DUSE_LD_GOLD=OFF
-DUSE_OPENGL_OR_ES=OFF
-DUSE_LCMS=OFF
-DUSE_SOUP2=ON
"
