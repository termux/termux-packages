TERMUX_PKG_HOMEPAGE=http://victornils.net/tetris/
TERMUX_PKG_DESCRIPTION="Virtual terminal *tris clone"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE_FILE="licence.txt"
TERMUX_PKG_VERSION=0.59.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/vicgeralds/vitetris/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=699443df03c8d4bf2051838c1015da72039bbbdd0ab0eede891c59c840bdf58d
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_REMOVE_AFTER_INSTALL="share/applications/vitetris.desktop"

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/configure" \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
