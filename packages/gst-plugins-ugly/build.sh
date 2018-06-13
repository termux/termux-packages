TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Ugly Plug-ins"
TERMUX_PKG_VERSION=1.14.1
TERMUX_PKG_SHA256=cff2430bb13f54ef81409a0b3d65ce409a376d4a7bab57a14a97d602539fe1d3
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base, libx264"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-examples
--disable-android_media
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"
