TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_SRCURL=git+https://github.com/denoland/deno
TERMUX_PKG_DEPENDS="libffi, libsqlite, glib, zlib"
TERMUX_PKG_BUILD_DEPENDS="librusty-v8"
TERMUX_PKG_BUILD_IN_SRC=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_BLACKLISTED_ARCHES="i686, arm"

termux_step_configure() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_protobuf

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	patch --silent -p1 \
		-d ./vendor/v8/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rusty-v8-search-files-with-target-suffix.diff

	patch --silent -p1 \
		-d "$TERMUX_PKG_SRCDIR" \
		< "$TERMUX_PKG_BUILDER_DIR"/patch-root-Cargo.diff

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p $_CARGO_TARGET_LIBDIR

	mv $TERMUX_PREFIX/lib/libz.so.1{,.tmp}
	mv $TERMUX_PREFIX/lib/libz.so{,.tmp}

	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.1.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so.1
	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so
}

termux_step_make() {
	local env_name=RUSTY_V8_ARCHIVE_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export "$env_name"="${TERMUX_PREFIX}/lib/librusty_v8.a"
	env_name=RUSTY_V8_SRC_BINDING_PATH_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export "$env_name"="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"

	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/deno"
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libz.so.1{.tmp,}
	mv $TERMUX_PREFIX/lib/libz.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}
