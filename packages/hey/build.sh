TERMUX_PKG_HOMEPAGE=https://github.com/rakyll/hey
TERMUX_PKG_DESCRIPTION="HTTP load generator, ApacheBench (ab) replacement"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.1.5"
TERMUX_PKG_SRCURL="https://github.com/rakyll/hey/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f678bc0f07c62a6513726298873940b70099aa85244efa813f6a0d925092ffe9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o hey \
		.
}

termux_step_make_install() {
	install -Dm755 hey "$TERMUX_PREFIX/bin/hey"
}
