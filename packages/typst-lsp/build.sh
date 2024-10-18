TERMUX_PKG_HOMEPAGE=https://github.com/nvarner/typst-lsp
TERMUX_PKG_DESCRIPTION="Language server for Typst"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT.txt, LICENSE-Apache-2.0.txt"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/nvarner/typst-lsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=860d56653b719402736b00ac9bc09e5e418dea2577cead30644252e85ab5d1a1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# We're not shipping the VS Code plugin
	rm -rf .vscode
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	patch --silent -p1 \
		-d ./vendor/time/ \
		< "$TERMUX_PKG_BUILDER_DIR"/time-items-format_items.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'time = { path = "./vendor/time" }' >> Cargo.toml
}

termux_step_post_make_install() {
	# Remove the vendor sources to save space
	rm -rf "$TERMUX_PKG_SRCDIR"/vendor
}
