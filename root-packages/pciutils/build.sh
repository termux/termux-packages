TERMUX_PKG_HOMEPAGE=https://mj.ucw.cz/sw/pciutils/
TERMUX_PKG_DESCRIPTION="a collection of programs for inspecting and manipulating configuration of PCI devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mj.ucw.cz/download/linux/pci/pciutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=08c27e01030d1fcc700d02bc2ea66c638f58a3d150e45e58852aa82ad4160d84
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	local ARCH=${TERMUX_ARCH}
	if [[ ${ARCH} == "arm" ]]; then
		ARCH="armv7l"
	fi

	# ${str^^} returns upper case string
	sed -i "s%\@TERMUX_ARCH\@%${ARCH^^}%g" ./lib/config.h
	sed -i "s%\@TERMUX_ARCH\@%${ARCH^^}%g" ./lib/config.mk
}
