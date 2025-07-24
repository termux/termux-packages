TERMUX_PKG_HOMEPAGE=https://github.com/facebookincubator/below
TERMUX_PKG_DESCRIPTION="An interactive tool to view and record historical system data"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_SRCURL=https://github.com/facebookincubator/below/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=04d837417acbfbbbcf58f028a4e527f4c392a459b6c1bf0fcf91a837a6cbc1dc
TERMUX_PKG_DEPENDS="libelf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf "$CARGO_HOME"/registry/src/*/nix-*
	rm -rf "$CARGO_HOME"/registry/src/*/libbpf-sys-*
	rm -rf "$CARGO_HOME"/registry/src/*/openat-*

	cargo update

	cargo fetch --target $CARGO_TARGET_NAME

	local d p
	for d in "$CARGO_HOME"/registry/src/*/libbpf-sys-*; do
		for p in libbpf-sys-0.6.0-1-libbpf-include-linux-{compiler,types}.h.diff; do
			patch --silent -p1 -d ${d} \
				< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
		done
	done

	for d in "$CARGO_HOME"/registry/src/*/nix-*; do
		patch --silent -p1 -d "$d" <  "$TERMUX_PKG_BUILDER_DIR"/nix-0.20.0-src-net-if_.rs.diff || :
	done

	for d in "$CARGO_HOME"/registry/src/*/openat-*; do
		patch --silent -p1 -d "$d" <  "$TERMUX_PKG_BUILDER_DIR"/openat-st_mode-32-bit.diff || :
	done

	local _CARGO_TARGET_LIBDIR=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $_CARGO_TARGET_LIBDIR
	local lib
	for lib in lib{elf,z}.so; do
		ln -sf $TERMUX_PREFIX/lib/${lib} $_CARGO_TARGET_LIBDIR/
	done

	# prevents "gcc: error: unrecognized command-line option '-mfpu=neon'" when targeting 32-bit
	unset CFLAGS
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/below
}
