TERMUX_PKG_HOMEPAGE=https://github.com/ameshkov/dnslookup
TERMUX_PKG_DESCRIPTION="Simple command line utility to make DNS lookups. Supports all known DNS protocols: plain DNS, DoH, DoT, DoQ, DNSCrypt."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="CHIZI-0618 <kay9925@outlook.com>"
TERMUX_PKG_VERSION="1.12.0"
TERMUX_PKG_SRCURL="https://github.com/ameshkov/dnslookup/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=de4b851a21556811f26739b480fedd2c9e4fd0b238f4a4e20143e1f64b42474f
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export CGO_ENABLED=1

	go build -ldflags "-X main.VersionString=v${TERMUX_PKG_VERSION}" -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
