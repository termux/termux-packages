TERMUX_PKG_HOMEPAGE=https://bundles.openttdcoop.org/opensfx
TERMUX_PKG_DESCRIPTION="Free sound set for openttd"

# Here should be CCSP, but unfortunately Bintray doesn't allow
# such license as well as other Creative Commons licenses except
# the CC0.
TERMUX_PKG_LICENSE="CC0-1.0"

TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.2.3
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://bundles.openttdcoop.org/opensfx/releases/$TERMUX_PKG_VERSION/opensfx-$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=3574745ac0c138bae53b56972591db8d778ad9faffd51deae37a48a563e71662
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 opensfx.* "$TERMUX_PREFIX"/share/openttd/data
}
