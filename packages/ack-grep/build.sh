TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_VERSION=2.28
TERMUX_PKG_SHA256=0ab3df19513a2c71aa7901f7f522a5baf72ce69e6e0e34879979f157210734f6
TERMUX_PKG_SRCURL=https://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file
TERMUX_PKG_SKIP_SRC_EXTRACT=yes
# Depend on coreutils for bin/env
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	termux_download \
		$TERMUX_PKG_SRCURL \
		$TERMUX_PREFIX/bin/ack \
		$TERMUX_PKG_SHA256
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
