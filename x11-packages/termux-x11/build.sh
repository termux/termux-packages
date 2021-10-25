TERMUX_PKG_HOMEPAGE=https://github.com/termux/x11-packages
TERMUX_PKG_DESCRIPTION="Utility to start X11 Termux add-on"
TERMUX_PKG_LICENSE="GPL-3.0" # same as Termux:X11 add-on app
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="libwayland"

termux_step_make_install() {
	$CC $CFLAGS $CPPFLAGS -DTERMUX_PREFIX=\"$TERMUX_PREFIX\" \
		$TERMUX_PKG_BUILDER_DIR/termux-x11.c -o $TERMUX_PREFIX/bin/termux-x11 \
		$LDFLAGS -lwayland-client
}
