TERMUX_PKG_HOMEPAGE=https://github.com/nvarner/typst-lsp
TERMUX_PKG_DESCRIPTION="Language server for Typst"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.12.1
TERMUX_PKG_SRCURL=https://github.com/nvarner/typst-lsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88c2053678147e6a3a01389644892f32244317f763622d19eaf7a64fe7e7e2dc
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# We're not shipping the VS Code plugin
	rm -rf .vscode
	termux_setup_rust
}
