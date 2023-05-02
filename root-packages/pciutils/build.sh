TERMUX_PKG_HOMEPAGE=https://mj.ucw.cz/sw/pciutils/
TERMUX_PKG_DESCRIPTION="a collection of programs for inspecting and manipulating configuration of PCI devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.10.0
TERMUX_PKG_SRCURL=https://mj.ucw.cz/download/linux/pci/pciutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7deabe38ae5fa88a96a8c4947975cf31c591506db546e9665a10dddbf350ead0
TERMUX_PKG_DEPENDS="libandroid-glob, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"

	# ${str^^} returns upper case string
	local _ARCH=${TERMUX_ARCH^^}
	if [[ ${_ARCH} == "ARM" ]]; then
		_ARCH="ARMV7L"
	fi

	local f
	for f in config.h config.mk; do
		local in=$TERMUX_PKG_BUILDER_DIR/$TERMUX_PKG_VERSION/${f}.in
		local out=$TERMUX_PKG_SRCDIR/lib/${f}
		sed \
			-e 's|@TERMUX_ARCH@|'"${_ARCH}"'|g' \
			-e 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' \
			${in} > ${out}
	done
}
