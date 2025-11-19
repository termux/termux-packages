TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.0"
TERMUX_PKG_SRCURL=https://beyondgrep.com/ack-v${TERMUX_PKG_VERSION}
TERMUX_PKG_SHA256=b8916abc9d42ebe8cc82264e047ccff5cbc976401e32a3dc6fc01c551c0cb5f8
TERMUX_PKG_AUTO_UPDATE=true
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
