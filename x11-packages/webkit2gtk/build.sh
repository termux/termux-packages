TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.32.3
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c1f496f5ac654efe4cef62fbd4f2fbeeef265a07c5e7419e5d2900bfeea52cbc
TERMUX_PKG_DEPENDS="enchant, gst-plugins-base, gstreamer, gtk3, libcairo, libgcrypt, libhyphen, libicu, libnotify, libsoup, libtasn1, libwebp, libxslt, libxt, openjpeg, woff2"
TERMUX_PKG_BREAKS="webkit, webkitgtk"
TERMUX_PKG_REPLACES="webkit, webkitgtk"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPORT=GTK
-DCMAKE_BUILD_TYPE=RelWithDebInfo
-DENABLE_GAMEPAD=OFF
-DUSE_SYSTEMD=OFF
-DUSE_LIBSECRET=OFF
-DENABLE_INTROSPECTION=OFF
-DUSE_WPE_RENDERER=OFF
"
