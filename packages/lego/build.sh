TERMUX_PKG_HOMEPAGE=https://github.com/go-acme/lego
TERMUX_PKG_DESCRIPTION="Let's Encrypt/ACME client and library written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="5.5.0"
TERMUX_PKG_SRCURL="https://github.com/go-acme/lego/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f35b85add7f25d8219993eda320e9f5947a6b266e464c92acc993aef985591ad
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	mkdir build
	go build -v \
		-trimpath \
		-ldflags "-X main.version=v${TERMUX_PKG_VERSION}" \
		-o build
}

termux_step_make_install() {
	install -Dm700 "build/${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
