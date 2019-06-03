TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://beyondgrep.com/ack-v${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=b9e342095fabb03da0159c69b4e5f99ce458c38ca8cbeafc7d03abcfd789536e
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_SKIP_SRC_EXTRACT=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	termux_download \
		$TERMUX_PKG_SRCURL \
		$TERMUX_PREFIX/bin/ack \
		$TERMUX_PKG_SHA256
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
