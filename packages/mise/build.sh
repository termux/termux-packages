TERMUX_PKG_HOMEPAGE=https://mise.jdx.dev/
TERMUX_PKG_DESCRIPTION="dev tools, env vars, task runner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.3.13"
TERMUX_PKG_SRCURL="https://github.com/jdx/mise/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=bb769fcae08a763190aa6f119d763f0bdb1523498b7fde053224956eda588339
TERMUX_PKG_DEPENDS="bzip2, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rattler_pty \
		-exec rm -rf '{}' \;

	patch="$TERMUX_PKG_BUILDER_DIR/rattler_pty-android-target.diff"
	dir="vendor/rattler_pty"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	cat <<-EOL >> Cargo.toml

		[patch.crates-io]
		rattler_pty = { path = "./vendor/rattler_pty" }
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
