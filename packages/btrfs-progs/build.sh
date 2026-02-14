TERMUX_PKG_HOMEPAGE=https://btrfs.readthedocs.io/en/latest/
TERMUX_PKG_DESCRIPTION="Utilities for Btrfs filesystem"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.19"
TERMUX_PKG_SRCURL=https://github.com/kdave/btrfs-progs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60547812c7397391ea48a804ecafa0d8b8a02a9708b56818bea603860dc4128d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="e2fsprogs, liblzo, libuuid, util-linux, zlib, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-backtrace
--disable-libudev
--disable-python
--disable-static
--disable-option-checking
"

termux_step_pre_configure() {
	./autogen.sh
	CFLAGS+=" $CPPFLAGS"
}
