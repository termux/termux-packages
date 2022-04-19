TERMUX_PKG_HOMEPAGE=https://cgit.freedesktop.org/mesa/glu/
TERMUX_PKG_DESCRIPTION="Mesa OpenGL Utility library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/glu/glu-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=24effdfb952453cc00e275e1c82ca9787506aba0282145fff054498e60e19a65

TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libexpat, libx11, libxau, libxcb, libxdamage, libxdmcp, libxext, libxfixes, libxshmfence, mesa, zlib"
TERMUX_PKG_CONFLICTS="libglu"
TERMUX_PKG_REPLACES="libglu"

termux_step_post_get_source() {
	cp "${TERMUX_PKG_BUILDER_DIR}"/LICENSE ./
}
