TERMUX_PKG_HOMEPAGE=https://github.com/openSUSE/hwinfo
TERMUX_PKG_DESCRIPTION="Hardware detection tool from openSUSE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=21.71
TERMUX_PKG_SRCURL=https://github.com/openSUSE/hwinfo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c4c573eb15cbc10103f5044b485d7e4ff941500ed559743a1c98e6a6deb0ebda
TERMUX_PKG_DEPENDS="libandroid-shmem, libuuid, libx86emu"
TERMUX_PKG_BREAKS="hwinfo-dev"
TERMUX_PKG_REPLACES="hwinfo-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo 'touch changelog' > git2log
	LDFLAGS+=" -landroid-shmem"
}

termux_step_make() {
	make -j1 HWINFO_VERSION="$TERMUX_PKG_VERSION" \
		LIBDIR="$TERMUX_PREFIX/lib"
}

termux_step_make_install() {
	make HWINFO_VERSION="$TERMUX_PKG_VERSION" \
		DESTDIR="$TERMUX_PREFIX" install
}
