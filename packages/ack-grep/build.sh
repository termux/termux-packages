TERMUX_PKG_HOMEPAGE=http://beyondgrep.com/
TERMUX_PKG_DESCRIPTION="Tool like grep optimized for programmers"
TERMUX_PKG_VERSION=2.14
# Depend on coreutils for bin/env.
TERMUX_PKG_DEPENDS="perl, coreutils"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	curl -o $TERMUX_PREFIX/bin/ack http://beyondgrep.com/ack-${TERMUX_PKG_VERSION}-single-file
	chmod +x $TERMUX_PREFIX/bin/ack
}
