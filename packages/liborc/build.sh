TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/projects/orc.html
TERMUX_PKG_DESCRIPTION="Library of Optimized Inner Loops Runtime Compiler"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.39"
TERMUX_PKG_SRCURL=https://github.com/GStreamer/orc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=37034939663e4eadc3d4f816fd449830c9468a69a65006d6f85b687c4a449827
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dorc-test=disabled
-Dtests=disabled
-Dbenchmarks=disabled
-Dexamples=disabled
-Dgtk_doc=disabled
"
