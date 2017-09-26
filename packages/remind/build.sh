TERMUX_PKG_HOMEPAGE=https://www.roaringpenguin.com/products/remind
TERMUX_PKG_DESCRIPTION="Sophisticated calendar and alarm program"
TERMUX_PKG_VERSION=3.1.15
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.roaringpenguin.com/files/download/remind-03.01.15.tar.gz
TERMUX_PKG_SHA256=8adab4c0b30a556c34223094c5c74779164d5f3b8be66b8039f44b577e678ec1
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="bin/tkremind share/man/man1/tkremind.1 bin/cm2rem.tcl share/man/man1/cm2rem.1"

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
