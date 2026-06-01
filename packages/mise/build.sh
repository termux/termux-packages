TERMUX_PKG_HOMEPAGE=https://mise.jdx.dev/
TERMUX_PKG_DESCRIPTION="dev tools, env vars, task runner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.5.18"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/jdx/mise/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f1a3b31060484207b1618746b526571c29ee7150e509c4229f33b1e512b2d667
TERMUX_PKG_DEPENDS="bzip2, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_pre_configure() {
	termux_setup_rust

	# Vendor cargo deps to ./vendor-termux/ - not ./vendor/ - because mise's
	# tree ships ./vendor/aqua-registry/ as build-time data (build.rs reads
	# vendor/aqua-registry/registry.yml). `cargo vendor` overwrites its
	# target directory, so pointing it at ./vendor/ deletes aqua-registry
	# and the build fails with `os error 2`.
	cargo vendor vendor-termux
	find ./vendor-termux \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor-termux/rattler_pty \
		! -wholename ./vendor-termux/cc \
		-exec rm -rf '{}' \;

	patch="$TERMUX_PKG_BUILDER_DIR/rattler_pty-android-target.diff"
	dir="vendor-termux/rattler_pty"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	dir="vendor-termux/cc"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	cat <<-EOL >> Cargo.toml

		[patch.crates-io]
		rattler_pty = { path = "./vendor-termux/rattler_pty" }
		cc = { path = "./vendor-termux/cc" }
	EOL

	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"

	# The `openssl-sys` crate fails to compile if we don't set this.
	# Declare and export separately, see http://shellcheck.net/wiki/SC2155
	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu

	# This variable specifically **does not** use SHOUT_CASE naming like the CARGO_TARGET_* variable above.
	# The `sys-info` crate fails to compile if we don't set this.
	export CFLAGS_"${CARGO_TARGET_NAME//-/_}"+=" -Dindex=strchr"
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	# mise binary
	install -vDm755 "target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME}" \
		-t "$TERMUX_PREFIX/bin"
	# man page
	install -vDm644 "man/man1/mise.1" \
		-t "${TERMUX_PREFIX}/share/man/man1"
	# shell completions
	install -vDm644 "completions/_${TERMUX_PKG_NAME}" \
		-t "${TERMUX_PREFIX}/share/zsh/site-functions"
	# The bash completion has a .bash extension which it shouldn't so fix that before installing it.
	mv -v "completions/${TERMUX_PKG_NAME}"{.bash,}
	install -vDm644 "completions/${TERMUX_PKG_NAME}" \
		-t "${TERMUX_PREFIX}/share/bash-completion/completions"
	install -vDm644 "completions/${TERMUX_PKG_NAME}.fish" \
		-t "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
}
