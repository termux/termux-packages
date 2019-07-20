TERMUX_PKG_HOMEPAGE=https://core.tcl.tk/expect/index
TERMUX_PKG_DESCRIPTION="Tool for automating interactive terminal applications"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_VERSION=5.45.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/expect/Expect/${TERMUX_PKG_VERSION}/expect${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="tcl"
TERMUX_PKG_BREAKS="expect-dev"
TERMUX_PKG_REPLACES="expect-dev"

termux_step_pre_configure() {
	autoconf
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -f -s expect${TERMUX_PKG_VERSION}/libexpect${TERMUX_PKG_VERSION}.so .
}
