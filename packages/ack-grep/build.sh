TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_VERSION=2.18
# Depend on coreutils for bin/env.
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download \
		https://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file \
		$TERMUX_PREFIX/bin/ack \
		6e41057c8f50f661d800099471f769209480efa53b8a886969d7ec6db60a2208
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
