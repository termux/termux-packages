TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/glvnd/libglvnd
TERMUX_PKG_DESCRIPTION="GLVND EGL vendor library that forwards to the device EGL and GLES"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_DEPENDS="libglvnd"
TERMUX_PKG_BUILD_DEPENDS="libglvnd-dev"
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_post_get_source() {
	cp "$TERMUX_PKG_BUILDER_DIR/LICENSE" "$TERMUX_PKG_SRCDIR/"
}

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -shared -fPIC -Wall \
		-Wl,-soname,libEGL_android.so.0 \
		-o "$TERMUX_PKG_BUILDDIR/libEGL_android.so.0" \
		"$TERMUX_PKG_BUILDER_DIR/EGL_android.c" -ldl
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR/libEGL_android.so.0" "$TERMUX_PREFIX/lib/libEGL_android.so.0"
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/00_android.json" "$TERMUX_PREFIX/share/glvnd/egl_vendor.d/00_android.json"
}
