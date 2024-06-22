TERMUX_PKG_HOMEPAGE=https://github.com/nvarner/typst-lsp
TERMUX_PKG_DESCRIPTION="Language server for Typst"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.13.0
TERMUX_PKG_SRCURL=https://github.com/nvarner/typst-lsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=860d56653b719402736b00ac9bc09e5e418dea2577cead30644252e85ab5d1a1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# We're not shipping the VS Code plugin
	rm -rf .vscode
	termux_setup_rust
}
