TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.1
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=42035145e29983308d2828207bb4ef933ed0407bb587fb3a569738c6a57fdb19
TERMUX_PKG_DEPENDS="gst-plugins-base, libx264"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"
