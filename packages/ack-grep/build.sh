TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_VERSION=2.20
# Depend on coreutils for bin/env
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download \
		https://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file \
		$TERMUX_PREFIX/bin/ack \
		fcdf3babf4264d126b362c9116eade83fe76f844f5de8f4150e54e0e83702e16
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
