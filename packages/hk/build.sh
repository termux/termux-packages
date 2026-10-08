TERMUX_PKG_HOMEPAGE=https://hk.jdx.dev/
TERMUX_PKG_DESCRIPTION="A tool for managing git hooks"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.0"
TERMUX_PKG_SRCURL="https://github.com/jdx/hk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7361e4428acc923a19d82c84a48c840f9ac1eff75afc1752b4ca41f24b8bf99e
TERMUX_PKG_DEPENDS="git, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	export CARGO_TARGET_DIR="$(dirname "$TERMUX_PKG_SRCDIR")/cargo-target"

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/aws-lc-sys \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys.diff"
	local dir="vendor/aws-lc-sys"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "$dir" < "$patch"

	# pklr fetches Pkl packages through reqwest, whose rustls-platform-verifier
	# takes its Android path through JNI, which a CLI has no JVM for.
	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	cat <<-EOL >> Cargo.toml

		[patch.crates-io]
		aws-lc-sys = { path = "./vendor/aws-lc-sys" }
		rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }
	EOL

	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--bin hk
}

termux_step_make_install() {
	install -vDm755 "$CARGO_TARGET_DIR/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME}" \
		-t "$TERMUX_PREFIX/bin"
}

termux_step_post_make_install() {
	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	# The `cargo run` invocations below are host builds.
	# Unset the target toolchain variables so they don't clash with the host
	# compiler used by build scripts.
	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		cargo run --bin hk -- completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
		cargo run --bin hk -- completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
		cargo run --bin hk -- completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	)
}
