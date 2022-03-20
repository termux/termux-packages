TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/projects/orc.html
TERMUX_PKG_DESCRIPTION="Library of Optimized Inner Loops Runtime Compiler"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.32
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GStreamer/orc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a7349d2ab4a73476cd4de36212e8c3c6524998081aaa04cf3a891ef792dd50f

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dorc-test=disabled
-Dtests=disabled
-Dbenchmarks=disabled
-Dexamples=disabled
-Dgtk_doc=disabled
"
