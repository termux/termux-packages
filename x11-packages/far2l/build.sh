TERMUX_PKG_HOMEPAGE=https://github.com/elfmz/far2l
TERMUX_PKG_DESCRIPTION="FAR Manager v2"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.0"
TERMUX_PKG_SRCURL="https://github.com/elfmz/far2l/archive/refs/tags/v_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0
TERMUX_PKG_DEPENDS="libandroid-utimes, libarchive, libc++, libuchardet"
TERMUX_PKG_SUGGESTS="chafa, exiftool, htop, timg"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/applications"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DANDROID=ON
-DUSEWX=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-utimes"
}
