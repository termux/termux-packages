TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/fullycapable/
TERMUX_PKG_DESCRIPTION="POSIX 1003.1e capabilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.43
TERMUX_PKG_SRCURL=https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=512a0e5fc4c1e06d472a20da26aa96a9b9bf2a26b23f094f77f1b8da56cc427f
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
