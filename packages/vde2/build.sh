TERMUX_PKG_HOMEPAGE=https://github.com/virtualsquare/vde-2
TERMUX_PKG_DESCRIPTION="Virtual Distributed Ethernet for emulators like qemu"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.libvdeplug, COPYING.slirpvde"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/vde/vde2-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=cbea9b7e03097f87a6b5e98b07890d2275848f1fe4b9fcda77b8994148bc9542
TERMUX_PKG_DEPENDS="libpcap,libtool , openssl, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-python"


termux_step_pre_configure() {
	autoreconf --install
	CFLAGS+=" -Dindex=strchr -Drindex=strrchr"
}
