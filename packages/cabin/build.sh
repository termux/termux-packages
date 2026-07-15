TERMUX_PKG_HOMEPAGE=https://cabinpkg.com/
TERMUX_PKG_DESCRIPTION="A package manager and build system for C/C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL="https://github.com/cabinpkg/cabin/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=226a228cadc3f5451492751db766d8e999de5f73c9e2a90226037741056b594c
TERMUX_PKG_SUGGESTS="clang, make, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="poac"
TERMUX_PKG_REPLACES="poac"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_configure() {
	# clash with rust host build
	# causes 32bit builds to fail if set
	unset CFLAGS
}

termux_step_make() {
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME}"

	mkdir -p "${TERMUX_PREFIX}/share/man/man1"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"

	cargo run -- mangen         > "${TERMUX_PREFIX}/share/man/man1/${TERMUX_PKG_NAME}.1"
	cargo run -- compgen    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	cargo run -- compgen   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	cargo run -- compgen   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- compgen elvish > "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
}
