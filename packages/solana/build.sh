TERMUX_PKG_HOMEPAGE=https://github.com/anza-xyz/agave
TERMUX_PKG_DESCRIPTION="Solana CLI binaries package provides the essential tools to interact with the Solana blockchain, including solana-cli, spl-token, agave-validator etc."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.14"
TERMUX_PKG_SRCURL="https://github.com/anza-xyz/agave/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b7e84caad554388a04e64c40f535b787fea3d1d24ead1ced4748294e8ed0214d
TERMUX_PKG_DEPENDS="libandroid-shmem, openssl, protobuf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="i686, arm"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_rust

	export PROTOC="$(command -v protoc)"
	export LDFLAGS+=" -landroid-shmem"

	# SYMLINK libclang.so.1 to libclang.so
	# without libclang.so `clang-sys` throws error
	local _libclang="$(find /usr/lib -name 'libclang-*.so.1' | sort -V | tail -1)"

	mkdir -p "$TERMUX_PKG_TMPDIR/libclang-tmp"
	ln -sf "$_libclang" "$TERMUX_PKG_TMPDIR/libclang-tmp/libclang.so"
	export LIBCLANG_PATH="$TERMUX_PKG_TMPDIR/libclang-tmp"

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/protobuf-src \
		-exec rm -rf '{}' \;

	# use installed protoc & skip compiling protobuf-src
	local protobuf_patch="$TERMUX_PKG_BUILDER_DIR/point-to-host-protoc.diff"
	patch -p1 -d ./vendor/protobuf-src <"$protobuf_patch"

	# disable hidapi features
	sed -i 's/default = \["linux-static-hidraw"\]/default = []/' remote-wallet/Cargo.toml
	sed -i '/^\[patch\.crates-io\]/a \
		protobuf-src = { path = "./vendor/protobuf-src" } \
		sys-info = { git = "https://github.com/FillZpp/sys-info-rs", rev = "refs/pull/118/head"}' Cargo.toml

}

termux_step_make() {
	# We use -p (package) instead of --bin to ensure we only build
	# the specific workspace members, which helps skip heavy validator code.
	cargo build \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--no-default-features \
		-p solana-cli \
		-p solana-keygen \
		-p agave-validator \
		-p solana-faucet \
		-p solana-stake-accounts \
		-p solana-tokens \
		-p solana-test-validator
}

termux_step_make_install() {
	# This will look for all compiled binaries in the release folder and install them
	local bin_dir="target/${CARGO_TARGET_NAME}/release"
	if [[ ! -d "$bin_dir" ]]; then
		bin_dir="target/release"
	fi

	local binaries=(
		"solana"
		"solana-keygen"
		"agave-validator"
		"solana-faucet"
		"solana-stake-accounts"
		"solana-tokens"
		"solana-test-validator"
	)

	for binary in "${binaries[@]}"; do
		if [[ -f "${bin_dir}/$binary" ]]; then
			install -Dm755 "${bin_dir}/$binary" "$TERMUX_PREFIX/bin/$binary"
		else
			echo "Warning: Binary $binary not found in $bin_dir, skipping."
		fi
	done
}
