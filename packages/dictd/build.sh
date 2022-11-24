TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dict/
TERMUX_PKG_DESCRIPTION="Online dictionary client and server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dict/dictd/dictd-${TERMUX_PKG_VERSION}/dictd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e4f1a67d16894d8494569d7dc9442c15cc38c011f2b9631c7f1cc62276652a1b
TERMUX_PKG_DEPENDS="libmaa, zlib"
TERMUX_PKG_CONFFILES="etc/dict.conf"

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/dict.conf $TERMUX_PREFIX/etc/dict.conf
}
