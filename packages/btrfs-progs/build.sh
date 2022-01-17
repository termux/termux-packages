TERMUX_PKG_HOMEPAGE=https://btrfs.wiki.kernel.org/
TERMUX_PKG_DESCRIPTION="Userspace utilities to manage btrfs filesystems"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.16
TERMUX_PKG_SRCURL=https://github.com/kdave/btrfs-progs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=19041e58a44656a8cd29c5c4baefde759c7e7ac522fa67c82f02db4e187131ec
TERMUX_PKG_DEPENDS="e2fsprogs, liblzo, libuuid, zstd"
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
