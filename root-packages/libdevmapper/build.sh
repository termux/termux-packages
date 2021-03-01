TERMUX_PKG_HOMEPAGE=https://sourceware.org/lvm2/
TERMUX_PKG_DESCRIPTION="A device-mapper library from LVM2 package"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.03.09
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=c03a8b8d5c03ba8ac54ebddf670ae0d086edac54a6577e8c50721a8e174eb975
TERMUX_PKG_DEPENDS="libandroid-support, libaio, readline"
TERMUX_PKG_BREAKS="libdevmapper-dev"
TERMUX_PKG_REPLACES="libdevmapper-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make -j"${TERMUX_MAKE_PROCESSES}" lib.device-mapper
}

termux_step_make_install() {
	cd libdm
	make install
}

