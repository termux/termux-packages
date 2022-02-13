TERMUX_PKG_HOMEPAGE=http://jodies.de/ipcalc
TERMUX_PKG_DESCRIPTION="Calculates IP broadcast, network, Cisco wildcard mask, and host ranges"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_VERSION=0.41
TERMUX_PKG_SRCURL=http://jodies.de/ipcalc-archive/ipcalc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dda9c571ce3369e5b6b06e92790434b54bec1f2b03f1c9df054c0988aa4e2e8a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/ ipcalc
}
