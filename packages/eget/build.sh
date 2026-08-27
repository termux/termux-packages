TERMUX_PKG_HOMEPAGE=https://github.com/zyedidia/eget
TERMUX_PKG_DESCRIPTION="Easily install prebuilt binaries from GitHub"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.3.4"
TERMUX_PKG_SRCURL=https://github.com/zyedidia/eget/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1d36e2e77caa5654c01efb890993f489fc6ae3b5b7f3e6fb0159fe946d6e7a06
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w -X main.Version=${TERMUX_PKG_VERSION}" \
		-o eget \
		.
}

termux_step_make_install() {
	install -Dm755 eget "$TERMUX_PREFIX/bin/eget"
}
