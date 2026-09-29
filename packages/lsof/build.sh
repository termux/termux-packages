TERMUX_PKG_HOMEPAGE=https://github.com/lsof-org/lsof
TERMUX_PKG_DESCRIPTION="Lists open files for running Unix processes"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.99.7"
TERMUX_PKG_SRCURL=https://github.com/lsof-org/lsof/archive/refs/tags/${TERMUX_PKG_VERSION}/lsof-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bac1b0acbc50aede42fc97dffaa0b0475e97973e36a6351de5f349c6155afc68
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libtirpc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-libtirpc
--with-selinux=no
"

termux_step_pre_configure() {
	autoreconf -fiv
}
