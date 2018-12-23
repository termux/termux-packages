TERMUX_PKG_HOMEPAGE=https://github.com/dgoulet/torsocks
TERMUX_PKG_DESCRIPTION="Wrapper to safely torify applications"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SHA256=817c143e8a9d217f41a223a85139c6ca28e1b99556c547fcdb4c72dbc170b6c9
TERMUX_PKG_SRCURL=https://github.com/dgoulet/torsocks/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="tor"

termux_step_pre_configure () {
	./autogen.sh
}

