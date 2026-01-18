TERMUX_PKG_HOMEPAGE=https://github.com/go-acme/lego
TERMUX_PKG_DESCRIPTION="Let's Encrypt/ACME client and library written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="4.31.0"
TERMUX_PKG_SRCURL="https://github.com/go-acme/lego/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e3504804193be4ab72ca9a40725b3632f204f20d92920a0e886250091e3dab6e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	mkdir build
	go build -v \
		-ldflags "-X main.version=v${TERMUX_PKG_VERSION}" \
		-o build \
		./cmd/...
}

termux_step_make_install() {
	install -Dm700 "build/${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
