TERMUX_PKG_HOMEPAGE=http://mj.ucw.cz/sw/pciutils/
TERMUX_PKG_DESCRIPTION="The PCI Utilities are a collection of programs for inspecting and manipulating configuration of PCI devices"
TERMUX_PKG_VERSION=3.5.6
TERMUX_PKG_SRCURL=ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/pciutils-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0d4d507d395e727384737d3c45cf8c5a0023864a6eb5c6ed7caf7d483995391d
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	local ARCH=$TERMUX_ARCH
	if [ $ARCH == "arm" ]; then
		ARCH="armv7l"
	fi

	# ${str^^} returns upper case string
	sed -i "s%\@TERMUX_ARCH\@%${ARCH^^}%g" ./lib/config.h
	sed -i "s%\@TERMUX_ARCH\@%${ARCH^^}%g" ./lib/config.mk
}
