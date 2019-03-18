TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/fullycapable/
TERMUX_PKG_DESCRIPTION="POSIX 1003.1e capabilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=2.26
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b630b7c484271b3ba867680d6a14b10a86cfa67247a14631b14c06731d5a458b
TERMUX_PKG_DEPENDS="attr"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make CC="$CC" PREFIX="$TERMUX_PREFIX"
}

termux_step_make_install() {
	make CC="$CC" prefix="$TERMUX_PREFIX" RAISE_SETFCAP=no lib=/lib install
}
