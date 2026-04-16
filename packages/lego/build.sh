TERMUX_PKG_HOMEPAGE=https://github.com/go-acme/lego
TERMUX_PKG_DESCRIPTION="Let's Encrypt/ACME client and library written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="4.34.0"
TERMUX_PKG_SRCURL="https://github.com/go-acme/lego/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=16d0dff7863fd6ab21d1be94ffdd88b6ec1bacb31ce5a57007d22407f7e23e38
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
