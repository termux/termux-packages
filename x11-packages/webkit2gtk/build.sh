TERMUX_PKG_HOMEPAGE=https://webkitgtk.org
TERMUX_PKG_DESCRIPTION="A full-featured port of the WebKit rendering engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.31.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://webkitgtk.org/releases/webkitgtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPORT=GTK -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_GAMEPAD=OFF -DUSE_SYSTEMD=OFF -DUSE_LIBSECRET=OFF -DENABLE_INTROSPECTION=OFF"
TERMUX_PKG_SHA256=6b1bb3e0efcfcb6e4a8e18b6a5f1cac27cda203d46a7dfbb0f150784a47e908f
TERMUX_PKG_DEPENDS="libtasn1, libxt, libnotify, libcairo, libgcrypt, gtk3, libsoup, libwebp, libxslt, woff2, enchant, libhyphen, openjpeg, gst-plugins-base, gstreamer"
TERMUX_PKG_BREAKS="webkit, webkitgtk"
TERMUX_PKG_REPLACES="webkit, webkitgtk"
