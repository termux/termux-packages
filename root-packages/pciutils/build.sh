TERMUX_PKG_HOMEPAGE=https://mj.ucw.cz/sw/pciutils/
TERMUX_PKG_DESCRIPTION="a collection of programs for inspecting and manipulating configuration of PCI devices"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_SRCURL=https://mj.ucw.cz/download/linux/pci/pciutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8953a785b2e3af414434b8fdcbfb75c90758819631001e60dd3afb89b22b2331
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
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
