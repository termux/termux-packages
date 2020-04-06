TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/fullycapable/
TERMUX_PKG_DESCRIPTION="POSIX 1003.1e capabilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.33
TERMUX_PKG_SRCURL=https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=08edeaba2757021aeec45c4eeec52566675e0e0f5d4f057284d729e04f2643d6
TERMUX_PKG_DEPENDS="attr"
TERMUX_PKG_BREAKS="libcap-dev"
TERMUX_PKG_REPLACES="libcap-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make CC="$CC -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags" PREFIX="$TERMUX_PREFIX"
}

termux_step_make_install() {
	make CC="$CC -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags" prefix="$TERMUX_PREFIX" RAISE_SETFCAP=no lib=/lib install
}
