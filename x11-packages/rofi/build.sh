TERMUX_PKG_HOMEPAGE=https://davatorium.github.io/rofi/
TERMUX_PKG_DESCRIPTION="A window switcher, application launcher and dmenu replacement"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL="https://github.com/davatorium/rofi/releases/download/$TERMUX_PKG_VERSION/rofi-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=6a55ee27f189ef9a1435cea329b146805b5dc830d8abc7a08c50a971521a8d8d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, libandroid-glob, libcairo, libwayland, libxcb, libxkbcommon, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper

	# ld.lld: error: undefined symbol: glob, globfree
	LDFLAGS+=" -landroid-glob"

	sed \
	"s|@TERMUX_PKG_VERSION@|${TERMUX_PKG_VERSION}|g" \
	"$TERMUX_PKG_BUILDER_DIR"/nkutils-git-version.h.in > "$TERMUX_PKG_SRCDIR"/subprojects/libnkutils/core/include/nkutils-git-version.h
}
