TERMUX_PKG_HOMEPAGE=https://cgit.freedesktop.org/mesa/glu/
TERMUX_PKG_DESCRIPTION="Mesa OpenGL Utility library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0.3
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/glu/glu-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f
TERMUX_PKG_DEPENDS="libc++, opengl"
TERMUX_PKG_CONFLICTS="libglu"
TERMUX_PKG_REPLACES="libglu"

termux_step_post_get_source() {
	cp "${TERMUX_PKG_BUILDER_DIR}"/LICENSE ./
}

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
