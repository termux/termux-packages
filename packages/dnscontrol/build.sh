TERMUX_PKG_HOMEPAGE=https://github.com/StackExchange/dnscontrol
TERMUX_PKG_DESCRIPTION="Infrastructure as code for DNS!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="4.31.1"
TERMUX_PKG_SRCURL="https://github.com/StackExchange/dnscontrol/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9bc7f62d2b8f295469cbd7dd36d74a3942f9cdb1984a1565b2eaf5c93b0d9ab8
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go build -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
