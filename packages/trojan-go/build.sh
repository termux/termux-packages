TERMUX_PKG_HOMEPAGE=https://p4gefau1t.github.io/trojan-go
TERMUX_PKG_DESCRIPTION="A Trojan proxy written in Go. An unidentifiable mechanism that helps you bypass GFW"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/p4gefau1t/trojan-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=925f02647dda944813f1eab0b71eac98b83eb5964ef5a6f63e89bc7eb4486c1f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy -compat=1.17
}

termux_step_make() {
	go build -tags "full"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin trojan-go
}
