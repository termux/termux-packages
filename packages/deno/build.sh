TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=git+https://github.com/denoland/deno
TERMUX_PKG_DEPENDS="libffi, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_EXCLUDED_ARCHES="i686, arm"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_protobuf

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/v8 \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/v8/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rusty-v8-search-files-with-target-suffix.diff

	echo "" >> Cargo.toml
	echo "[patch.crates-io]" >> Cargo.toml
	echo "v8 = { path = \"./vendor/v8\" }" >> Cargo.toml

	# Download and extract the prebuilt snapshots
	local _SHA256SUM
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_SHA256SUM="bf4b49ea164280f81b8bd2a25a994ae95b68bf440de26e2e2fa5dbb3b2de323d"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_SHA256SUM="7d7c744396865ee0fcbf2d09a23c265a4a378d418f965eeafff659fb2dd2ae3a"
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi
	termux_download \
		"https://github.com/licy183/deno-snapshot/releases/download/v$TERMUX_PKG_VERSION/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION.tar.bz2" \
		"$TERMUX_PKG_CACHEDIR"/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION.tar.bz2 \
		$_SHA256SUM
	rm -rf $TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION
	mkdir -p $TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION
	tar -xf $TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION.tar.bz2 \
		-C $TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION \
		--strip-components=1
}

termux_step_make() {
	local env_name=${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export RUSTY_V8_ARCHIVE_${env_name}="${TERMUX_PREFIX}/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH_${env_name}="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"
	export DENO_SKIP_CROSS_BUILD_CHECK=1
	export DENO_PREBUILT_CLI_SNAPSHOT="$TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION/CLI_SNAPSHOT.bin"
	export DENO_PREBUILT_COMPILER_SNAPSHOT="$TERMUX_PKG_CACHEDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION/COMPILER_SNAPSHOT.bin"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export PKG_CONFIG_x86_64_unknown_linux_gnu=/usr/bin/pkg-config
		export PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig
	fi

	# ld.lld: error: undefined symbol: __clear_cache
	if [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		export CARGO_TARGET_${env_name}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/deno"
}
