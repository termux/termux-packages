TERMUX_PKG_HOMEPAGE=http://expect.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Tool for automating interactive terminal applications"
TERMUX_PKG_VERSION=5.45.3
TERMUX_PKG_SHA256=c520717b7195944a69ce1492ec82ca0ac3f3baf060804e6c5ee6d505ea512be9
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/expect/Expect/${TERMUX_PKG_VERSION}/expect${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libutil, tcl"

termux_step_pre_configure () {
	autoconf
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/lib
	ln -f -s expect${TERMUX_PKG_VERSION}/libexpect${TERMUX_PKG_VERSION}.so .
}
