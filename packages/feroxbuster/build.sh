TERMUX_PKG_HOMEPAGE="https://github.com/epi052/feroxbuster"
TERMUX_PKG_DESCRIPTION="A fast, simple, recursive content discovery tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.2"
TERMUX_PKG_SRCURL="https://github.com/epi052/feroxbuster/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7120613f966b311d3c7cca888c9f033a48a22edbc7ec4078c3d8dbfd3a327dda
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
# FIXME Why building with 'openssl' fails?
# ld: error: undefined symbol: ERR_get_error_all
# >>> referenced by feroxbuster.52795224-cgu.0 >>>
# ... -cgu.0.rcgu.o:(openssl::error::Error::get::hfccd210421e4f03c)
# clang-14: error: linker command failed with exit code 1
TERMUX_PKG_DEPENDS="openssl-1.1"

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_post_make_install() {
	# shell completions
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell_completions/feroxbuster.bash" \
		"$TERMUX_PREFIX"/share/bash-completion/completions/feroxbuster
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell_completions/_feroxbuster" \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_feroxbuster
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell_completions/feroxbuster.fish" \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/feroxbuster.fish
}
