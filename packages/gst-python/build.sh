TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Python bindings for GStreamer"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.7"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9c23c5dddfd2c9b94bb1b4e4f5b90ebc6400d84277c77cf91b1dbdb4a8b451f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gst-plugins-base, gst-plugins-bad, gstreamer, pygobject, python"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"
