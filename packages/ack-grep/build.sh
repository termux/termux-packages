TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_VERSION=2.24
TERMUX_PKG_SHA256=8361e5a2654bc575db27bfa40470c4182d74d51098d390944d98fe7cd5b20d49
TERMUX_PKG_SRCURL=https://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file
TERMUX_PKG_SKIP_SRC_EXTRACT=yes
# Depend on coreutils for bin/env
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download \
		$TERMUX_PKG_SRCURL \
		$TERMUX_PREFIX/bin/ack \
		$TERMUX_PKG_SHA256
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
