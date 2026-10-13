TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/mkcert
TERMUX_PKG_DESCRIPTION="A simple zero-config tool to make locally trusted development certificates"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.4.4"
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/mkcert/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32bd5519581bf0b03f53e5b22721692b99f39ab5b161dc27532c51eafa512ca9
TERMUX_PKG_SUGGESTS="nss-utils"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o mkcert \
		.
}

termux_step_make_install() {
	install -Dm755 mkcert "$TERMUX_PREFIX/bin/mkcert"
}
