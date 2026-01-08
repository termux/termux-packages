TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/projects/orc.html
TERMUX_PKG_DESCRIPTION="Library of Optimized Inner Loops Runtime Compiler"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.42"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/gstreamer/orc/-/archive/${TERMUX_PKG_VERSION}/orc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f5c3f614de5bd4a6522ba3c24a93b99d06c9f773ef5618252269d7f40251456
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dorc-test=disabled
-Dtests=disabled
-Dbenchmarks=disabled
-Dexamples=disabled
-Dhotdoc=disabled
"
