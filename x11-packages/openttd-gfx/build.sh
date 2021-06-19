TERMUX_PKG_HOMEPAGE=https://dev.openttdcoop.org/projects/opengfx
TERMUX_PKG_DESCRIPTION="A free graphics set for openttd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.5.5
TERMUX_PKG_REVISION=23
TERMUX_PKG_SRCURL=https://cdn.openttd.org/opengfx-releases/$TERMUX_PKG_VERSION/opengfx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=c648d56c41641f04e48873d83f13f089135909cc55342a91ed27c5c1683f0dfe
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_get_source() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/opengfx-$TERMUX_PKG_VERSION.zip" \
		"$TERMUX_PKG_SHA256"
	unzip -d "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_CACHEDIR/opengfx-$TERMUX_PKG_VERSION.zip"

	cd "$TERMUX_PKG_SRCDIR"
	tar xf "opengfx-$TERMUX_PKG_VERSION.tar"
}

termux_step_make_install() {
	cd "opengfx-$TERMUX_PKG_VERSION"
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.grf "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.obg "$TERMUX_PREFIX"/share/openttd/data
}
