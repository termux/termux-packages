TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_VERSION=3.3.1
TERMUX_PKG_SRCURL=https://beyondgrep.com/ack-v${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=e4fd286d5a56f459147d562660d2f8bc4548f2f1e2d8cf3a5265b70beedbfc87
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	termux_download \
		$TERMUX_PKG_SRCURL \
		$TERMUX_PREFIX/bin/ack \
		$TERMUX_PKG_SHA256
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
