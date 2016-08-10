TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Open source multimedia framework"
TERMUX_PKG_VERSION=1.8.2
TERMUX_PKG_SRCURL=http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-tests --disable-examples"
