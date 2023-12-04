TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/parole/start
TERMUX_PKG_DESCRIPTION="Parole is a media player for the Xfce desktop environment, written using the GStreamer framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/parole/${TERMUX_PKG_VERSION%.*}/parole-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0c7364a484812f69cf2b20a2323864203334cc854fd8103d1d1131814ac55a66
# gstreamer all plugins for all support in parole
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, gdk-pixbuf, glib, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gst-plugins-ugly, gstreamer, gtk3, harfbuzz, libcairo, libnotify, libx11, libxfce4ui, libxfce4util, pango, taglib, xfconf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
