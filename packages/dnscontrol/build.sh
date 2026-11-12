TERMUX_PKG_HOMEPAGE=https://dnscontrol.org/
TERMUX_PKG_DESCRIPTION="Infrastructure as code for DNS!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="5.8.1"
TERMUX_PKG_SRCURL="https://github.com/DNSControl/dnscontrol/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=71d0a9e71487dce36ece540bba14920d9ea6fb4dea3d1873aac0eeb250e63757
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go build -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
