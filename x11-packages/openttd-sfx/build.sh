TERMUX_PKG_HOMEPAGE=https://bundles.openttdcoop.org/opensfx
TERMUX_PKG_DESCRIPTION="Free sound set for openttd"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://cdn.openttd.org/opensfx-releases/$TERMUX_PKG_VERSION/opensfx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/opensfx-$TERMUX_PKG_VERSION.zip" \
		"$TERMUX_PKG_SHA256"
	unzip -d "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_CACHEDIR/opensfx-$TERMUX_PKG_VERSION.zip"

	cd "$TERMUX_PKG_SRCDIR"
	tar xf "opensfx-$TERMUX_PKG_VERSION.tar" --strip-components=1
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 opensfx.* "$TERMUX_PREFIX"/share/openttd/data
}
