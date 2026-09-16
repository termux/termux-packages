TERMUX_PKG_HOMEPAGE=https://jj-vcs.github.io/jj/
TERMUX_PKG_DESCRIPTION="A Git-compatible VCS that is both simple and powerful"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.43.0"
TERMUX_PKG_SRCURL=https://github.com/jj-vcs/jj/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d230327737ee506b716c6ae5ac824c49951c34e117a024dc7aa38819809ea6c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="liblz4, xz-utils, openssl"
TERMUX_PKG_SUGGESTS="openssl"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 \
		"target/${CARGO_TARGET_NAME}/release/jj" \
		"${TERMUX_PREFIX}/bin/jj"
}

termux_step_post_make_install() {
	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	mkdir -p "${TERMUX_PREFIX}/share/nushell/vendor/autoload"

	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		cargo run --bin jj -- util completion   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/jj"
		cargo run --bin jj -- util completion   zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_jj"
		cargo run --bin jj -- util completion  fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/jj.fish"
		cargo run --bin jj -- util completion elvish > "${TERMUX_PREFIX}/share/elvish/lib/jj.elv"
		cargo run --bin jj -- util completion nushell > "${TERMUX_PREFIX}/share/nushell/vendor/autoload/jj.nu"
	)
}
