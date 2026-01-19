TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
TERMUX_PKG_DESCRIPTION="Miscellaneous system utilities"
TERMUX_PKG_LICENSE="GPL-3.0-or-later, GPL-2.0-or-later, LGPL-2.1-or-later, BSD 3-Clause, BSD, ISC"
TERMUX_PKG_LICENSE_FILE="
	Documentation/licenses/COPYING.GPL-3.0-or-later
	Documentation/licenses/COPYING.GPL-2.0-or-later
	Documentation/licenses/COPYING.LGPL-2.1-or-later
	Documentation/licenses/COPYING.BSD-3-Clause
	Documentation/licenses/COPYING.BSD-4-Clause-UC
	Documentation/licenses/COPYING.ISC
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.41.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${TERMUX_PKG_VERSION:0:4}/util-linux-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6062a1d89b571a61932e6fc0211f36060c4183568b81ee866cf363bce9f6583e
# <dependency>: <binaries linking to that dependency>
# libandroid-glob: lsclocks
# libandroid-posix-semaphore: lsipc and the lib{blkid,smartcols,uuid} subpackages
# libcap-ng: setpriv
# libsmartcols: cal, column, fincore, irqtop, losetup, lsclocks, lscpu, lsfd, lsipc, lsirq, prlimit, wdctl, zramctl
# ncurses: cal, dmesg, hexdump, irqtop, setterm, ul
# zlib: fsck.cramfs
#
# libcrypt would be required for newgrp and sulogin, which we are not building
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-posix-semaphore, libcap-ng, libsmartcols, ncurses, zlib"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BREAKS="util-linux-dev"
TERMUX_PKG_REPLACES="util-linux-dev"
# Most android kernels are built without namespace support, so remove lsns
TERMUX_PKG_RM_AFTER_INSTALL="
bin/lsns
share/bash-completion/completions/lsns
share/man/man8/lsns.8.gz
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setns=yes
ac_cv_func_statx=no
ac_cv_func_unshare=yes
ac_cv_func_uselocale=no
ac_cv_type_struct_statx=no
--enable-setpriv
--disable-agetty
--disable-ctrlaltdel
--disable-eject
--disable-fdformat
--disable-ipcmk
--disable-ipcrm
--disable-ipcs
--disable-kill
--disable-last
--disable-liblastlog2
--disable-logger
--disable-mesg
--disable-makeinstall-chown
--disable-mountpoint
--disable-nologin
--disable-pivot_root
--disable-poman
--disable-raw
--disable-switch_root
--disable-wall
--disable-lsmem
--disable-chmem
--disable-rfkill
--disable-hwclock-cmos
"

termux_step_pre_configure() {
	case "$TERMUX_ARCH_BITS" in
		#prlimit() is only available in 64-bit bionic.
		64) TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_prlimit=yes";;
		32) TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038";;
	esac

	LDFLAGS+=" -landroid-posix-semaphore"
}
