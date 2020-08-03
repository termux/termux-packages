TERMUX_PKG_HOMEPAGE=http://victornils.net/tetris/
TERMUX_PKG_DESCRIPTION="Virtual terminal *tris clone"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="licence.txt"
TERMUX_PKG_VERSION=0.58.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vicgeralds/vitetris/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7e7cb74bb814b9fec80fe4ede3c3f04134d8217d630e092a097238248d604f9
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_REMOVE_AFTER_INSTALL="share/applications/vitetris.desktop"

termux_step_configure() {
	"$TERMUX_PKG_SRCDIR/configure" \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
