TERMUX_PKG_HOMEPAGE=https://github.com/eza-community/eza
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.2"
TERMUX_PKG_SRCURL=https://github.com/eza-community/eza/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2fcde456b04c8aebe72fcd9a3f73feca58dc5de1f1edf40de9387c211dbba8a
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

termux_step_create_debscripts() {
	# This is a temporary notice and should be removed in the future
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash

		echo "===Package replacement notice==="
		echo "exa has been replaced, by it's maintained community fork eza."
		echo
		echo "See:"
		echo "https://github.com/ogham/exa#exa-is-unmaintained-use-the-fork-eza-instead"
		echo "For more information."
		echo
		echo "Your options and aliases for exa may need to be updated"
		echo "================================"
		echo

	exit 0
	POSTINST_EOF

	chmod 0755 postinst

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}

