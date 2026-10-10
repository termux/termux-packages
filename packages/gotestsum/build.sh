TERMUX_PKG_HOMEPAGE=https://github.com/gotestyourself/gotestsum
TERMUX_PKG_DESCRIPTION="'go test' runner with output optimized for humans, JUnit XML for CI integration, and a summary of the test results"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL=https://github.com/gotestyourself/gotestsum/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e64d58e1bf4f4c4b82b3a703ed5046ea2b4eb827d2a7ba2ead3216bb5fb85547
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gotestsum \
		.
}

termux_step_make_install() {
	install -Dm755 gotestsum "$TERMUX_PREFIX/bin/gotestsum"
}
