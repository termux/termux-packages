TERMUX_PKG_HOMEPAGE=https://github.com/wojtekka/6tunnel
TERMUX_PKG_DESCRIPTION="Allows you to use services provided by IPv6 hosts with IPv4-only applications and vice-versa"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14"
TERMUX_PKG_SRCURL=https://github.com/wojtekka/6tunnel/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f597edda55db4b6e661d7afdaa17c1f0c41aeadc21fc8b5599e678595906552b
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fi
}
