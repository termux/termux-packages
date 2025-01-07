TERMUX_PKG_HOMEPAGE=https://github.com/facebookincubator/below
TERMUX_PKG_DESCRIPTION="An interactive tool to view and record historical system data"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/facebookincubator/below/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bfeb9cd911e0477a5428ee0b6cbf7cbdc7eba90b716ac1e4f6cbadcde2ffbcb1
TERMUX_PKG_DEPENDS="libelf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

# ```
# error[E0308]: mismatched types
#    --> /home/builder/.cargo/registry/src/github.com-1ecc6299db9ec823/openat-0.1.21/src/dir.rs:465:34
#     |
# 465 |             match stat.st_mode & libc::S_IFMT {
#     |                                  ^^^^^^^^^^^^ expected `u32`, found `u16`
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target $CARGO_TARGET_NAME

	local d p
	for d in $CARGO_HOME/registry/src/*/libbpf-sys-*; do
		for p in libbpf-sys-0.6.0-1-libbpf-include-linux-{compiler,types}.h.diff; do
			patch --silent -p1 -d ${d} \
				< "$TERMUX_PKG_BUILDER_DIR/${p}" || :
		done
	done

	local _CARGO_TARGET_LIBDIR=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $_CARGO_TARGET_LIBDIR
	local lib
	for lib in lib{elf,z}.so; do
		ln -sf $TERMUX_PREFIX/lib/${lib} $_CARGO_TARGET_LIBDIR/
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/below
}
