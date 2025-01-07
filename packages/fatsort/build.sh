TERMUX_PKG_HOMEPAGE=https://fatsort.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A C utility that sorts FAT12, FAT16, FAT32 and exFAT partitions"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.5.640
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/fatsort/fatsort-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=630ece56d9eb3a55524af0aec3aade7854360eba949172a6cfb4768cb8fbe42e
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
MANDIR=$TERMUX_PREFIX/share/man/man1
SBINDIR=$TERMUX_PREFIX/bin
"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -liconv"
}
