TERMUX_PKG_HOMEPAGE=https://github.com/cweill/gotests
TERMUX_PKG_DESCRIPTION="Generates Go tests from your source code"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=https://github.com/cweill/gotests/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a36874dd5beec211e9b9aaf7d72be8839e76b5ad0a002cb4e83b80ad948697b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gotests-bin \
		./gotests
}
termux_step_make_install() {
	install -Dm755 gotests-bin "$TERMUX_PREFIX/bin/gotests"
}
