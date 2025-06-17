TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_SRCURL=(
	https://github.com/denoland/deno/releases/download/v$TERMUX_PKG_VERSION/deno_src.tar.gz
	https://github.com/licy183/deno-snapshot/releases/download/v$TERMUX_PKG_VERSION/deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION.tar.bz2
	https://github.com/licy183/deno-snapshot/releases/download/v$TERMUX_PKG_VERSION/deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION.tar.bz2
)
TERMUX_PKG_SHA256=(
	f892a4f2fd12964dd4a49f4f7e5639911611b202babb3ef523dcb01a4c76e9fb
	bf4b49ea164280f81b8bd2a25a994ae95b68bf440de26e2e2fa5dbb3b2de323d
	7d7c744396865ee0fcbf2d09a23c265a4a378d418f965eeafff659fb2dd2ae3a
)
TERMUX_PKG_DEPENDS="libffi, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_EXCLUDED_ARCHES="i686, arm"

termux_step_get_source() {
	# XXX: Add version to the name of deno src tarball
	local _target_name=(
		"deno_src-$TERMUX_PKG_VERSION.tar.gz"
		"deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION.tar.bz2"
		"deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION.tar.bz2"
	)
	local _target_path=(
		"$TERMUX_PKG_SRCDIR"
		"$TERMUX_PKG_SRCDIR/deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION"
		"$TERMUX_PKG_SRCDIR/deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION"
	)
	local i=0
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		local file="$TERMUX_PKG_CACHEDIR"/"${_target_name[$i]}"
		local path="${_target_path[$i]}"
		termux_download "${TERMUX_PKG_SRCURL[$i]}" "$file" "${TERMUX_PKG_SHA256[$i]}"
		mkdir -p "$path"
		tar xf "$file" -C "$path" --strip-components=1
	done
}

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

	# Check v8 version
	local cv=$(. $TERMUX_PKG_BUILDER_DIR/../librusty-v8/build.sh; echo $TERMUX_PKG_VERSION)
	local ev=$(cargo info v8 | grep -e "^version:" | sed -n 's/^version:[[:space:]]*\([0-9.]*\).*/\1/p')
	if [ "${ev}" != "${cv}" ]; then
		termux_error_exit "The versions of librusty-v8 mismatch. Expected: $ev, current: $cv"
	fi
}

termux_step_make() {
	termux_setup_rust

	local env_name=${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export RUSTY_V8_ARCHIVE_${env_name}="${TERMUX_PREFIX}/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH_${env_name}="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"
	export DENO_SKIP_CROSS_BUILD_CHECK=1
	export DENO_PREBUILT_CLI_SNAPSHOT="$TERMUX_PKG_SRCDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION/CLI_SNAPSHOT.bin"
	export DENO_PREBUILT_COMPILER_SNAPSHOT="$TERMUX_PKG_SRCDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION/COMPILER_SNAPSHOT.bin"

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
