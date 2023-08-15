TERMUX_PKG_HOMEPAGE=https://github.com/ameshkov/dnslookup
TERMUX_PKG_DESCRIPTION="Simple command line utility to make DNS lookups. Supports all known DNS protocols: plain DNS, DoH, DoT, DoQ, DNSCrypt."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_SRCURL="https://github.com/ameshkov/dnslookup/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0f9b19f57c0d2fbae03e6ba2f652af017e3ceb8f8ed2a3efb3f983e48bc304fe
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GO_USE_OLDER=false

termux_step_make() {
	termux_setup_golang

	go build -ldflags "-X main.VersionString=v${TERMUX_PKG_VERSION}" -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 ./${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin
}
