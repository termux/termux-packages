TERMUX_PKG_HOMEPAGE=https://just.systems
TERMUX_PKG_DESCRIPTION="A handy way to save and run project-specific commands"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="1.38.0"
TERMUX_PKG_SRCURL=https://github.com/casey/just/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3d47e27755d39f40e1ca34bc0ef535fa514e7ed547b2af62311dcadd8bd6d564
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_configure() {
	# clash with rust host build
	# causes 32bit builds to fail if set
	unset CFLAGS
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	cargo run -- --man | gzip -c -f -n > "${TERMUX_PREFIX}/share/man/man1/just.1.gz"
	cargo run -- --completions    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_just"
	cargo run -- --completions   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/just"
	cargo run -- --completions   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/just.fish"
	cargo run -- --completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/just.elv"
}
