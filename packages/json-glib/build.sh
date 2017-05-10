TERMUX_PKG_HOMEPAGE="https://git.gnome.org/browse/json-glib/"
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_VERSION=1.2.8
TERMUX_PKG_SRCURL=https://git.gnome.org/browse/json-glib/snapshot/json-glib-1.2.8.tar.xz
#TERMUX_PKG_FOLDERNAME=babl-BABL_0_1_24
TERMUX_PKG_SHA256=3decd608d4bdb19c2bdfe0be49d67486ec7e238bbb5d32ebfa334eedfdba3593
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure() {
export THREAD_LIB="-lc"
	LDFLAGS+=" -landroid-support"
	NOCONFIGURE=1 	./autogen.sh
}
