TERMUX_PKG_HOMEPAGE=https://github.com/alexpasmantier/television
TERMUX_PKG_DESCRIPTION="A very fast, portable and hackable fuzzy finder"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.15.9"
TERMUX_PKG_SRCURL="https://github.com/alexpasmantier/television/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5f46cbe7b14e1d6e3958f436b1d6ed8af86e9914d7d2aee5a9379e8e1772072d
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm755 \
		"target/${CARGO_TARGET_NAME}/release/tv" \
		"${TERMUX_PREFIX}/bin/tv"
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
	#!${TERMUX_PREFIX}/bin/sh
	tv completions zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_tv"
	tv completions bash > "${TERMUX_PREFIX}/share/bash-completion/completions/tv"
	tv completions fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/tv.fish"
	# nu isn't supported by the completions subcommand, init covers it instead
	tv init nu > "${TERMUX_PREFIX}/share/nushell/vendor/autoload/tv.nu"
	EOF

	cat <<-EOF >./prerm
	#!${TERMUX_PREFIX}/bin/sh
	rm -f "${TERMUX_PREFIX}/share/zsh/site-functions/_tv"
	rm -f "${TERMUX_PREFIX}/share/bash-completion/completions/tv"
	rm -f "${TERMUX_PREFIX}/share/fish/vendor_completions.d/tv.fish"
	rm -f "${TERMUX_PREFIX}/share/nushell/vendor/autoload/tv.nu"
	EOF
}
