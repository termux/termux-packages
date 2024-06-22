TERMUX_PKG_HOMEPAGE=https://github.com/ameshkov/dnslookup
TERMUX_PKG_DESCRIPTION="Simple command line utility to make DNS lookups. Supports all known DNS protocols: plain DNS, DoH, DoT, DoQ, DNSCrypt."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL="https://github.com/ameshkov/dnslookup/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c9464093b76ba593fae3629ae54f5738251de48d8fc3bbdc08a9d6644416dfa0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_GO_USE_OLDER=false

termux_step_make() {
	termux_setup_golang

	export CGO_ENABLED=1

	go build -ldflags "-X main.VersionString=v${TERMUX_PKG_VERSION}" -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin
}
