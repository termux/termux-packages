TERMUX_PKG_HOMEPAGE=https://github.com/virtualsquare/vde-2
TERMUX_PKG_DESCRIPTION="Virtual Distributed Ethernet for emulators like qemu"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=https://github.com/virtualsquare/vde-2.git
TERMUX_PKG_DEPENDS="libpcap,libtool , openssl, libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-python"

termux_step_pre_configure() {
	autoreconf --install
	CFLAGS+=" -Drindex=strrchr"
}
termux_step_make(){
	make V=1
}
