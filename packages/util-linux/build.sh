TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
TERMUX_PKG_DESCRIPTION="Miscellaneous system utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.36
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${TERMUX_PKG_VERSION:0:4}/util-linux-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9e4b1c67eb13b9b67feb32ae1dc0d50e08ce9e5d82e1cccd0ee771ad2fa9e0b1
TERMUX_PKG_DEPENDS="ncurses, libcrypt, zlib"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BREAKS="util-linux-dev"
TERMUX_PKG_REPLACES="util-linux-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setns=yes
ac_cv_func_unshare=yes
--disable-agetty
--disable-ctrlaltdel
--disable-eject
--disable-fdformat
--disable-ipcrm
--disable-ipcs
--disable-kill
--disable-last
--disable-libuuid
--disable-logger
--disable-mesg
--disable-nologin
--disable-pivot_root
--disable-raw
--disable-switch_root
--disable-wall
--disable-libmount
--disable-lsmem
--disable-chmem
--disable-rfkill
--disable-hwclock-cmos
"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH_BITS = 64 ]; then
		#prlimit() is only available in 64-bit bionic.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_prlimit=yes"
	fi
}
