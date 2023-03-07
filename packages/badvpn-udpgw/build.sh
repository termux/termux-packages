TERMUX_PKG_HOMEPAGE=https://github.com/ambrop72/badvpn
TERMUX_PKG_DESCRIPTION="UDP gateway for BadVPN"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.999.130
TERMUX_PKG_SRCURL=https://github.com/ambrop72/badvpn/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfd4bbfebd7274bcec792558c9a2fd60e39cd92e04673825ade5d04154766109

termux_step_configure() {
	:
}

termux_step_make() {
	SRCDIR="$TERMUX_PKG_SRCDIR" ENDIAN=little KERNEL=2.4 \
		bash "$TERMUX_PKG_SRCDIR/compile-udpgw.sh"
}

termux_step_make_install() {
	install -Dm700 -T udpgw $TERMUX_PREFIX/bin/badvpn-udpgw
}
