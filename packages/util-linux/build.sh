TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
TERMUX_PKG_DESCRIPTION="Miscellaneous system utilities"
TERMUX_PKG_LICENSE="GPL-3.0, GPL-2.0, LGPL-2.1, BSD 3-Clause, BSD, ISC"
TERMUX_PKG_LICENSE_FILE="\
Documentation/licenses/COPYING.GPL-3.0-or-later
Documentation/licenses/COPYING.GPL-2.0-or-later
Documentation/licenses/COPYING.LGPL-2.1-or-later
Documentation/licenses/COPYING.BSD-3-Clause
Documentation/licenses/COPYING.BSD-4-Clause-UC
Documentation/licenses/COPYING.ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.37.4
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${TERMUX_PKG_VERSION:0:4}/util-linux-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=634e6916ad913366c3536b6468e7844769549b99a7b2bf80314de78ab5655b83
# libcrypt is required for only newgrp and sulogin, which are not built anyways
TERMUX_PKG_DEPENDS="ncurses, libcap-ng, zlib"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BREAKS="util-linux-dev"
TERMUX_PKG_REPLACES="util-linux-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setns=yes
ac_cv_func_unshare=yes
--enable-setpriv
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
