TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/parole/start
TERMUX_PKG_DESCRIPTION="Parole is a media player for the Xfce desktop environment, written using the GStreamer framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/parole/${_MAJOR_VERSION}/parole-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=bbe52fbc4d3abe30f6c79fc7ac57bd9de9cf74ce1a79b508a1d7de83dc4f3771
# gstreamer all plugins for all support in parole
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, gdk-pixbuf, glib, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gst-plugins-ugly, gstreamer, gtk3, harfbuzz, libcairo, libnotify, libx11, libxfce4ui, libxfce4util, pango, taglib, xfconf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
