TERMUX_PKG_HOMEPAGE=https://github.com/lsof-org/lsof
TERMUX_PKG_DESCRIPTION="Lists open files for running Unix processes"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.99.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lsof-org/lsof/archive/${TERMUX_PKG_VERSION}/lsof-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c591556c665196e0aada5982ff43c75e248187bad78bb1368d8fb9c1c527e6e
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
