TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Python bindings for GStreamer"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.11"
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-python/gst-python-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f4c8761bfee98508f57e2efd738ef36a99e2f7644860877d54d235a7092cf056
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gst-plugins-base, gstreamer, pygobject, python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=disabled
"
