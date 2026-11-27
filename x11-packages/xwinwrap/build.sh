TERMUX_PKG_HOMEPAGE=https://github.com/mmhobi7/xwinwrap
TERMUX_PKG_DESCRIPTION="Run a program as your X11 wallpaper"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@Keytaro2"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://github.com/mmhobi7/xwinwrap/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1792f59c5d85fc766f356f8f903a2081fe4dccc5e8e61cdd946bae0438d15d9a
TERMUX_PKG_DEPENDS="libx11, libxext, libxrender"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_LICENSE_FILE=LICENSE

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS xwinwrap.c -o xwinwrap -lX11 -lXext -lXrender
}

termux_step_make_install() {
	install -Dm755 xwinwrap "$TERMUX_PREFIX/bin/xwinwrap"
}

termux_step_post_get_source() {
	sed -n '1,24p' "$TERMUX_PKG_SRCDIR/xwinwrap.c" > "$TERMUX_PKG_SRCDIR/LICENSE"
}
