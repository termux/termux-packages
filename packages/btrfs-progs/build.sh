TERMUX_PKG_HOMEPAGE=https://btrfs.readthedocs.io/en/latest/
TERMUX_PKG_DESCRIPTION="Utilities for Btrfs filesystem"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.2
TERMUX_PKG_SRCURL=https://github.com/kdave/btrfs-progs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=561a99d402d2788586756fb2b90295f709ec339bd4466c05a6e7c439dd0fe2f4
TERMUX_PKG_DEPENDS="e2fsprogs, liblzo, libuuid, util-linux, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-backtrace
--disable-libudev
--disable-python
"

termux_step_pre_configure() {
	sh autogen.sh

	CFLAGS+=" $CPPFLAGS"
}
