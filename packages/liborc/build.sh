TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/projects/orc.html
TERMUX_PKG_DESCRIPTION="Library of Optimized Inner Loops Runtime Compiler"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.43"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/gstreamer/orc/-/archive/${TERMUX_PKG_VERSION}/orc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a19c0739889dd3109810850d2821d4146a6d7bab912114d0448db5117bc70c5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dorc-test=disabled
-Dtests=disabled
-Dbenchmarks=disabled
-Dexamples=disabled
-Dhotdoc=disabled
"
