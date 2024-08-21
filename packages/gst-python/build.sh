TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Python bindings for GStreamer"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.7"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6c3ee02b20c80a86e24245b06102dae00e017686f27407626f44dc03ac3ca53a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gst-plugins-base, gstreamer, pygobject, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"
