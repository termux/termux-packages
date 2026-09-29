TERMUX_PKG_HOMEPAGE=https://github.com/openSUSE/hwinfo
TERMUX_PKG_DESCRIPTION="Hardware detection tool from openSUSE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=26.0
TERMUX_PKG_SRCURL=https://github.com/openSUSE/hwinfo/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7774b23bc271a15b8db8f90b7c92ab0409c781a794163c0eb372c96a9c7fc293
TERMUX_PKG_DEPENDS="libandroid-shmem, libuuid, libx86emu, perl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+$'
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
