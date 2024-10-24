TERMUX_PKG_HOMEPAGE=https://tigervnc.org/
TERMUX_PKG_DESCRIPTION="A viewer (client) for Virtual Network Computing"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.1"
TERMUX_PKG_SRCURL=https://github.com/TigerVNC/tigervnc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=579d0d04eb5b806d240e99a3c756b38936859e6f7db2f4af0d5656cc9a989d7c
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
