TERMUX_PKG_HOMEPAGE=https://ice-wm.org/
TERMUX_PKG_DESCRIPTION="Window manager with goals of speed, simplicity, and usability"
TERMUX_PKG_LICENSE="LGPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8.2"
TERMUX_PKG_SRCURL="https://github.com/ice-wm/icewm/releases/download/$TERMUX_PKG_VERSION/icewm-$TERMUX_PKG_VERSION.tar.lz"
TERMUX_PKG_SHA256=c64b1b7c8ee262a3c4796be57349a3198998564d70ed26f11e724e1b73d48394
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="alsa-lib, imlib2, libandroid-glob, libandroid-wordexp, librsvg, libsndfile, libxcomposite, libxdamage, libxinerama, libxpm, libxrandr, libxres"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_SUGGESTS="xdg-menu"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
		patch="$TERMUX_PKG_BUILDER_DIR/genpref.diff"
		echo "Applying patch: $(basename "$patch")"
		patch --silent -p1 < "$patch"
	fi

	LDFLAGS+=" -landroid-glob -landroid-wordexp"

	# Every instance of '/usr' in the code is replaceable with '$TERMUX_PREFIX'.
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e "s|/usr|$TERMUX_PREFIX|g" \
		-e "s|/etc|$TERMUX_PREFIX/etc|g"
}
