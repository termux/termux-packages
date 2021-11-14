TERMUX_PKG_HOMEPAGE=http://jodies.de/ipcalc
TERMUX_PKG_DESCRIPTION="Calculates IP broadcast, network, Cisco wildcard mask, and host ranges"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_VERSION=0.51
TERMUX_PKG_SRCURL=https://github.com/kjokjo/ipcalc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a4dbfaeb7511b81830793ab9936bae9d7b1b561ad33e29106faaaf97ba1c117e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/ ipcalc
}
