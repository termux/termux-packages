TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/parole/start
TERMUX_PKG_DESCRIPTION="Parole is a media player for the Xfce desktop environment, written using the GStreamer framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_REVISION=5
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/p/parole/parole_${TERMUX_PKG_VERSION}.orig.tar.bz2
TERMUX_PKG_SHA256=0d305ad8ccd3974d6b632f74325b1b8a39304c905c6b405b70f52c4cfd55a7e7
# gstreamer all plugins for all support in parole
TERMUX_PKG_DEPENDS="gtk3, gstreamer, gst-plugins-base, gst-plugins-bad, gst-plugins-good, gst-plugins-ugly, atk, libcairo, dbus-glib, libnotify, pango, libxfce4util, libxfce4ui, xfconf, taglib, gst-libav"
TERMUX_PKG_BUILD_IN_SRC=true
