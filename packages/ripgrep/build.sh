TERMUX_PKG_HOMEPAGE=https://github.com/BurntSushi/ripgrep
TERMUX_PKG_DESCRIPTION="Search tool like grep and The Silver Searcher"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="15.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=046fa01a216793b8bd2750f9d68d4ad43986eb9c0d6122600f993906012972e8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pcre2"
TERMUX_PKG_RECOMMENDS="brotli, lz4"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features pcre2"

termux_step_post_make_install() {
	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	cargo run -- --generate complete-bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}.bash"
	cargo run -- --generate complete-fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- --generate complete-zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"

	# Man page
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	cargo run -- --generate man > "${TERMUX_PREFIX}/share/man/man1/${TERMUX_PKG_NAME}.1"
}
