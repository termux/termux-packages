TERMUX_PKG_HOMEPAGE=https://snowflake.torproject.org/
TERMUX_PKG_DESCRIPTION="Pluggable Transport using WebRTC, inspired by Flashproxy"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.2"
TERMUX_PKG_SRCURL=https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/archive/v${TERMUX_PKG_VERSION}/snowflake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b539a069eb3996d20a63eef9af59b43adb740ea121c954edf13b2bb6102b7112
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o snowflake-client $TERMUX_PKG_SRCDIR/client/
	go build -o snowflake-proxy $TERMUX_PKG_SRCDIR/proxy/
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin snowflake-client
	install -Dm700 -t $TERMUX_PREFIX/bin snowflake-proxy
}
