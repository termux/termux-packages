TERMUX_PKG_HOMEPAGE=http://expect.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Tool for automating interactive terminal applications"
TERMUX_PKG_VERSION=5.45
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/expect/Expect/${TERMUX_PKG_VERSION}/expect${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b28dca90428a3b30e650525cdc16255d76bb6ccd65d448be53e620d95d5cc040
TERMUX_PKG_DEPENDS="libutil, tcl"

termux_step_pre_configure () {
	autoconf
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/lib
	ln -f -s expect${TERMUX_PKG_VERSION}/libexpect${TERMUX_PKG_VERSION}.so .
}
