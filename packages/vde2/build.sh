TERMUX_PKG_HOMEPAGE=https://github.com/virtualsquare/vde-2
TERMUX_PKG_DESCRIPTION="Virtual Distributed Ethernet for emulators like qemu"
TERMUX_PKG_LICENSE="CUSTOM, GPL, LGPL"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/vde/vde2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cbea9b7e03097f87a6b5e98b07890d2275848f1fe4b9fcda77b8994148bc9542
TERMUX_PKG_DEPENDS="libpcap, openssl, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-gnu-ld  --disable-python"
#ac_cv_path_PYTHON=${TERMUX_PREFIX}/bin/python PYTHON_CONFIG=${TERMUX_PREFIX}/bin/python-config"

termux_step_pre_configure() {
	autoreconf --install
#	sed 's/"$PYTHON_CFLAGS"/`@TERMUX_PREFIX@\/bin\/python-config\ --includes`/g' -i configure
}
