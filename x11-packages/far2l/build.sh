TERMUX_PKG_HOMEPAGE=https://github.com/elfmz/far2l
TERMUX_PKG_DESCRIPTION="FAR Manager v2"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.1"
TERMUX_PKG_SRCURL="https://github.com/elfmz/far2l/archive/refs/tags/v_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a28d647f12b17fce3a89e939ce036fe4ef0d4fb1a9fc7c44fe27d292021522e4
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
