TERMUX_PKG_HOMEPAGE="https://github.com/epi052/feroxbuster"
TERMUX_PKG_DESCRIPTION="A fast, simple, recursive content discovery tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.0"
TERMUX_PKG_SRCURL="https://github.com/epi052/feroxbuster/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=0eaf51f4c7848d85d8059e030c9dba9d25eecc7fdad7e90806734e4af85cf779
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openssl"

termux_step_post_get_source() {
	sed -i -E '/^openssl\s*=/s/(,\s*)?"vendored"//g' Cargo.toml
}

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
