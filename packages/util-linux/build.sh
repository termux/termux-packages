TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
TERMUX_PKG_DESCRIPTION="Miscellaneous system utilities"
TERMUX_PKG_VERSION=2.33
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=f261b9d73c35bfeeea04d26941ac47ee1df937bd3b0583e748217c1ea423658a
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${TERMUX_PKG_VERSION:0:4}/util-linux-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="ncurses, libutil, libcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setns=yes
ac_cv_func_unshare=yes
--disable-agetty
--disable-eject
--disable-ipcrm
--disable-ipcs
--disable-kill
--disable-last
--disable-libuuid
--disable-logger
--disable-pivot_root
--disable-switch_root
--disable-wall
--disable-libmount
--disable-lsmem
--disable-chmem
--disable-rfkill
"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH_BITS = 64 ]; then
		# prlimit() is only available in 64-bit bionic.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_prlimit=yes"
	fi
}
