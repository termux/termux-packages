TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/parole/start
TERMUX_PKG_DESCRIPTION="Parole is a media player for the Xfce desktop environment, written using the GStreamer framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/parole/${TERMUX_PKG_VERSION%.*}/parole-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6625288b760d38a15c295051ecf66c556fcad21dd1516d6d661c2a582421ee0e
TERMUX_PKG_AUTO_UPDATE=true
# gstreamer all plugins for all support in parole
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, gdk-pixbuf, glib, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gst-plugins-ugly, gstreamer, gtk3, harfbuzz, libcairo, libnotify, libx11, libxfce4ui, libxfce4util, pango, taglib, xfconf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-gtk-doc-html=no
--enable-taglib
--enable-wayland
--enable-x11
"
