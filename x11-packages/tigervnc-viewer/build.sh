TERMUX_PKG_HOMEPAGE=https://tigervnc.org/
TERMUX_PKG_DESCRIPTION="A viewer (client) for Virtual Network Computing"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.15.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/TigerVNC/tigervnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f231906801e89f09a212e86701f3df1722e36767d6055a4e619390570548537
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
