TERMUX_PKG_HOMEPAGE=https://dev.openttdcoop.org/projects/opengfx
TERMUX_PKG_DESCRIPTION="A free graphics set for openttd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.1
TERMUX_PKG_SRCURL=https://cdn.openttd.org/opengfx-releases/$TERMUX_PKG_VERSION/opengfx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/opengfx-$TERMUX_PKG_VERSION.zip" \
		"$TERMUX_PKG_SHA256"
	unzip -d "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_CACHEDIR/opengfx-$TERMUX_PKG_VERSION.zip"

	cd "$TERMUX_PKG_SRCDIR"
	tar xf "opengfx-$TERMUX_PKG_VERSION.tar" --strip-components=1
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.grf "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.obg "$TERMUX_PREFIX"/share/openttd/data
}
