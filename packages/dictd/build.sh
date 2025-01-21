TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dict/
TERMUX_PKG_DESCRIPTION="Online dictionary client and server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.3"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dict/dictd/dictd-${TERMUX_PKG_VERSION}/dictd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=192129dfb38fa723f48a9586c79c5198fc4904fec1757176917314dd073f1171
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmaa, zlib"
TERMUX_PKG_CONFFILES="etc/dict.conf"
TERMUX_PKG_EXTRA_MAKE_ARGS="LEX=flex"

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/dict.conf $TERMUX_PREFIX/etc/dict.conf
}
