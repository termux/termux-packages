TERMUX_PKG_HOMEPAGE=https://github.com/openSUSE/hwinfo
TERMUX_PKG_DESCRIPTION="Hardware detection tool from openSUSE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.72
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/openSUSE/hwinfo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=60eb6cde92512f12e67139b57bff03b1deb2b56e614d6023068b09560d5255c2
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
