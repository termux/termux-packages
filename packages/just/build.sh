TERMUX_PKG_HOMEPAGE=https://just.systems
TERMUX_PKG_DESCRIPTION="A handy way to save and run project-specific commands"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@flipee"
TERMUX_PKG_VERSION="1.46.0"
TERMUX_PKG_SRCURL=https://github.com/casey/just/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f60a578502d0b29eaa2a72c5b0d91390b2064dfd8d1a1291c3b2525d587fd395
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

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

	# Move the `just` binary to $PREFIX/libexec
	# and replace it with our --ceiling shim.
	# See: packages/just/just-shim.sh for details.
	mkdir -p "$TERMUX_PREFIX/libexec/just"
	mv "${TERMUX_PREFIX}"/bin/just "${TERMUX_PREFIX}"/libexec/just
	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_HOME@|${TERMUX_ANDROID_HOME}|g" \
		"$TERMUX_PKG_BUILDER_DIR/just-shim.sh" \
		> "${TERMUX_PREFIX}/bin/just"
	chmod 700 "${TERMUX_PREFIX}/bin/just"
}
