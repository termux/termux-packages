TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/parole/start
TERMUX_PKG_DESCRIPTION="Parole is a media player for the Xfce desktop environment, written using the GStreamer framework."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"

TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/parole/${TERMUX_PKG_VERSION%.*}/parole-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5cf753e670d6518701133eb860d8bceb3a08a496af6a2b7cc67b93320230c983
TERMUX_PKG_AUTO_UPDATE=true
# gstreamer all plugins for all support in parole
TERMUX_PKG_DEPENDS="dbus, dbus-glib, gdk-pixbuf, glib, gst-libav, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gst-plugins-ugly, gstreamer, gtk3, libcairo, libnotify, libx11, libxfce4ui, libxfce4util, taglib, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk-doc=false
-Dmpris2-plugin=enabled
-Dnotify-plugin=enabled
-Dtaglib=enabled
-Dtray-plugin=enabled
-Dwayland=enabled
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
