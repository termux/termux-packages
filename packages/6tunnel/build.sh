TERMUX_PKG_HOMEPAGE=https://github.com/wojtekka/6tunnel
TERMUX_PKG_DESCRIPTION="Allows you to use services provided by IPv6 hosts with IPv4-only applications and vice-versa"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13
TERMUX_PKG_SRCURL=https://github.com/wojtekka/6tunnel/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9f15ae24116ab2e781dc5a73faf9bb699b694cf845c9122ea755ab1780751f01

termux_step_pre_configure() {
	autoreconf -fi
}
