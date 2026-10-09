TERMUX_PKG_HOMEPAGE=https://codeberg.org/forgejo-contrib/forgejo-cli
TERMUX_PKG_DESCRIPTION="CLI tool for Forgejo"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL="https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8b91194cb1886f253261a4567ee6f83aa34b05a9637644793f88b40b7110322a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgit2, libssh2, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_NO_VENDOR=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1

	termux_setup_cmake
	termux_setup_rust

	if [[ "${TERMUX_ARCH}" == "x86_64" ]]; then
		local -u env_host="${CARGO_TARGET_NAME//-/_}"
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	# Vendor and patch:
	# 1. ssh2-config: remove its unused build script, which needlessly pulls git2 and openssl-sys into host build-dependencies.
	# 2. rustls-platform-verifier: disable Android APK JNI verifier which panics in CLI environments without JVM.
	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/ssh2-config \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	sed -i -e '/^build = /d' vendor/ssh2-config/Cargo.toml
	sed -i -e '/\[build-dependencies/,$d' vendor/ssh2-config/Cargo.toml

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	cat >> Cargo.toml <<-EOF

		[patch.crates-io]
		ssh2-config = { path = "./vendor/ssh2-config" }
		rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }
	EOF

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local f
	for f in "$CARGO_HOME"/registry/src/*/libgit2-sys-*/build.rs; do
		sed -i -E 's/\.range_version\(([^)]*)\.\.[^)]*\)/.atleast_version(\1)/g' "${f}"
	done
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/fj"
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		unset OPENSSL_NO_VENDOR LIBGIT2_SYS_USE_PKG_CONFIG LIBSSH2_SYS_USE_PKG_CONFIG
		export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig:${PKG_CONFIG_PATH:-}"

		mkdir -p "${HOME}/.local/share/forgejo-cli"
		echo '{"hosts":{}}' > "${HOME}/.local/share/forgejo-cli/keys.json"

		cargo run -- completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/fj"
		cargo run -- completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_fj"
		cargo run -- completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/fj.fish"
	)
}
