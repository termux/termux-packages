TERMUX_PKG_HOMEPAGE=https://github.com/eza-community/eza
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.20.20"
TERMUX_PKG_SRCURL=https://github.com/eza-community/eza/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8731184ff1b1d3dbd6bb8fda8f750780a58ccac682fd6344d92160dc518937de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgit2"
TERMUX_PKG_BREAKS="exa"
TERMUX_PKG_REPLACES="exa"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in $CARGO_HOME/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done

	CFLAGS="$CPPFLAGS"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,5}
	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/eza.1.md --output $TERMUX_PREFIX/share/man/man1/eza.1
	pandoc --standalone --to man $TERMUX_PKG_SRCDIR/man/eza_colors.5.md --output $TERMUX_PREFIX/share/man/man5/eza_colors.5
	install -Dm600 completions/bash/eza $TERMUX_PREFIX/share/bash-completion/completions/eza
	install -Dm600 completions/fish/eza.fish $TERMUX_PREFIX/share/fish/vendor_completions.d/eza.fish
	install -Dm600 completions/zsh/_eza $TERMUX_PREFIX/share/zsh/site-functions/_eza
}
