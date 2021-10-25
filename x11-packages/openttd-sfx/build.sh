TERMUX_PKG_HOMEPAGE=https://bundles.openttdcoop.org/opensfx
TERMUX_PKG_DESCRIPTION="Free sound set for openttd"
TERMUX_PKG_LICENSE="CCSP"
TERMUX_PKG_LICENSE_FILE="license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.3
TERMUX_PKG_REVISION=24
TERMUX_PKG_SRCURL=https://cdn.openttd.org/opensfx-releases/$TERMUX_PKG_VERSION/opensfx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=6831b651b3dc8b494026f7277989a1d757961b67c17b75d3c2e097451f75af02
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 opensfx.* "$TERMUX_PREFIX"/share/openttd/data
}
