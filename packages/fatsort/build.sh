TERMUX_PKG_HOMEPAGE=https://fatsort.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A C utility that sorts FAT12, FAT16, FAT32 and exFAT partitions"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.4.625
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/fatsort/fatsort-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9a6f89a0640bb782d82ff23a780c9f0aec3dfbe4682c0a8eda157e0810642ead
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
