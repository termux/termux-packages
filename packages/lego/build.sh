TERMUX_PKG_HOMEPAGE=https://github.com/go-acme/lego
TERMUX_PKG_DESCRIPTION="Let's Encrypt/ACME client and library written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="4.32.0"
TERMUX_PKG_SRCURL="https://github.com/go-acme/lego/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=368870300da2b25d669a6d09f57565af4c7a3907edda2678f8aa34b58bb0484c
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
