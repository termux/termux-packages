TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/projects/orc.html
TERMUX_PKG_DESCRIPTION="Library of Optimized Inner Loops Runtime Compiler"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.35"
TERMUX_PKG_SRCURL=https://github.com/GStreamer/orc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85116f6aed0a14a612548909b56da82537d1b743b14c65bfa1045db1c7703871
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dorc-test=disabled
-Dtests=disabled
-Dbenchmarks=disabled
-Dexamples=disabled
-Dgtk_doc=disabled
"
