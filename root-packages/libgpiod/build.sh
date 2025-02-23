TERMUX_PKG_HOMEPAGE=https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git
TERMUX_PKG_DESCRIPTION="C library and tools for interacting with the GPIO character device. Requires kernel v4.6 or higher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL="https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ae35329db7027c740e90c883baf27c26311f0614e6a7b115771b28188b992aec
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-tools=yes
ac_cv_func_versionsort=yes
"

termux_step_pre_configure() {
	autoreconf -vfi
}
