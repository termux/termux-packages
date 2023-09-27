TERMUX_PKG_HOMEPAGE=https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git
TERMUX_PKG_DESCRIPTION="Utilities to control the kernel key management facility"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a61d5706136ae4c05bd48f86186bcfdbd88dd8bd5107e3e195c924cfc1b39bb4
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -Dindex=strchr -Drindex=strrchr"
}
