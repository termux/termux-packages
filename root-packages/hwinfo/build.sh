TERMUX_PKG_HOMEPAGE=https://github.com/openSUSE/hwinfo
TERMUX_PKG_DESCRIPTION="Hardware detection tool from openSUSE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.2
TERMUX_PKG_SRCURL=https://github.com/openSUSE/hwinfo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=53f55f9072f0dddf36439645e70fda82431327cd2262a741390af4bd665b6713
TERMUX_PKG_DEPENDS="libandroid-shmem, libuuid (>> 2.38.1), libx86emu"
TERMUX_PKG_BREAKS="hwinfo-dev"
TERMUX_PKG_REPLACES="hwinfo-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i -E '/^SUBDIRS\s*=/d' Makefile
	echo -e '\n$(LIBHD):\n\t$(MAKE) -C src' >> Makefile
	echo -e '\t$(CC) -shared $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) \' >> Makefile
	echo -e '\t\t-Wl,--whole-archive $(LIBHD) -Wl,--no-whole-archive \' >> Makefile
	echo -e '\t\t-Wl,-soname=$(LIBHD_SONAME) -o $(LIBHD_SO) $(SO_LIBS)' >> Makefile
}

termux_step_configure() {
	echo 'touch changelog' > git2log
	LDFLAGS+=" -landroid-shmem"
	export HWINFO_VERSION="$TERMUX_PKG_VERSION"
	export DESTDIR="$TERMUX_PREFIX"
}
