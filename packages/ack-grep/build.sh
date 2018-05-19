TERMUX_PKG_HOMEPAGE=https://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_VERSION=2.22
# Depend on coreutils for bin/env
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download \
		https://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file \
		$TERMUX_PREFIX/bin/ack \
		fd0617585b88517a3d41d3d206c1dc38058c57b90dfd88c278049a41aeb5be38
	touch $TERMUX_PREFIX/bin/ack
	chmod +x $TERMUX_PREFIX/bin/ack
}
