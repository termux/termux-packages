TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.7"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9539e7f928c42fb77ec6b52f4527f3837d263d250f9659a0d8e1d378f38bbfc8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/crates/ruff"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"

	cd $TERMUX_PKG_BUILDDIR
	rm -rf _lib
	mkdir -p _lib
	cd _lib
	$CC $CPPFLAGS $CFLAGS -fvisibility=hidden \
		-c $TERMUX_PKG_BUILDER_DIR/ctermid.c
	$AR cru libctermid.a ctermid.o

	RUSTFLAGS+=" -C link-arg=$TERMUX_PKG_BUILDDIR/_lib/libctermid.a"

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cd $TERMUX_PKG_SRCDIR
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_PKG_BUILDER_DIR/tikv-jemalloc-sys-0.5.3+5.3.0-patched-src-lib.rs.diff
	local d
	for d in $CARGO_HOME/registry/src/*/tikv-jemalloc-sys-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}
