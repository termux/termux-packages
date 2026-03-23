TERMUX_PKG_HOMEPAGE=https://github.com/elfmz/far2l
TERMUX_PKG_DESCRIPTION="FAR Manager v2"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.0"
TERMUX_PKG_SRCURL=https://github.com/elfmz/far2l/archive/refs/tags/v_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0fddad2e3985f245f9e691e23b90fb97f7d29d9a0b131fe686aa3cbb2e4ea01
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
