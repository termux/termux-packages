TERMUX_PKG_HOMEPAGE=https://github.com/jolars/panache
TERMUX_PKG_DESCRIPTION="Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.14.0
TERMUX_PKG_SRCURL=https://github.com/jolars/panache/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=68a89fa8438e2caa2a64cda7219544529299959a15f74bce36c744319c48a618
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features all"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	install -Dm600 target/completions/panache.bash "${TERMUX_PREFIX}/share/bash-completion/completions/panache"
	install -Dm600 target/completions/panache.fish -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	install -Dm600 target/completions/_panache -t "${TERMUX_PREFIX}/share/zsh/site-functions"

	# Man page
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	install -Dm600 target/man/* -t "${TERMUX_PREFIX}/share/man/man1"
}
