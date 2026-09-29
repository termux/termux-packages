TERMUX_PKG_HOMEPAGE=https://tigervnc.org/
TERMUX_PKG_DESCRIPTION="A viewer (client) for Virtual Network Computing"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.16.2"
TERMUX_PKG_SRCURL="https://github.com/TigerVNC/tigervnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b107c0c8b8a962594281690366c24186e95c2ea4a169acbc0076aa62ed01f467
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fltk, libandroid-shmem, libc++, libgmp, libgnutls, libjpeg-turbo, libnettle, libpixman, libx11, libxext, libxi, libxrandr, libxrender, zlib"
TERMUX_PKG_CONFLICTS="tigervnc (<< 1.9.0-4)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SERVER=OFF
-DENABLE_NLS=OFF
-DFLTK_MATH_LIBRARY=
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
}
