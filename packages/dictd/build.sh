TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dict/
TERMUX_PKG_DESCRIPTION="Online dictionary client and server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dict/dictd/dictd-${TERMUX_PKG_VERSION}/dictd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eeba51af77e87bb1b166c6bc469aad463632d40fb2bdd65e6675288d8e1a81e4
TERMUX_PKG_DEPENDS="libmaa, zlib"
TERMUX_PKG_CONFFILES="etc/dict.conf"

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/dict.conf $TERMUX_PREFIX/etc/dict.conf
}
