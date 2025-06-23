TERMUX_PKG_HOMEPAGE=https://btrfs.readthedocs.io/en/latest/
TERMUX_PKG_DESCRIPTION="Utilities for Btrfs filesystem"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.15"
TERMUX_PKG_SRCURL=https://github.com/kdave/btrfs-progs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f10d3f639595a041d64651fea9b0d593addb4057118b35f5938b5b4618548a4
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
