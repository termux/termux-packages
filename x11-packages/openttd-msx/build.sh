TERMUX_PKG_HOMEPAGE=https://bundles.openttdcoop.org/openmsx
TERMUX_PKG_DESCRIPTION="Free music set for openttd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.2
TERMUX_PKG_SRCURL=https://cdn.openttd.org/openmsx-releases/$TERMUX_PKG_VERSION/openmsx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/openmsx-$TERMUX_PKG_VERSION.zip" \
		"$TERMUX_PKG_SHA256"
	unzip -d "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_CACHEDIR/openmsx-$TERMUX_PKG_VERSION.zip"

	cd "$TERMUX_PKG_SRCDIR"
	tar xf "openmsx-$TERMUX_PKG_VERSION.tar" --strip-components=1
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 openmsx.obm "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.mid "$TERMUX_PREFIX"/share/openttd/data
}
