TERMUX_PKG_HOMEPAGE="https://github.com/charliermarsh/ruff"
TERMUX_PKG_DESCRIPTION="An extremely fast Python linter, written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.256"
TERMUX_PKG_SRCURL="https://github.com/charliermarsh/ruff/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6775785dfaf7e749db2de55a922d5ac4b3cfd01b50cc670c792deb5d498dbd19
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/crates/ruff_cli"
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
	for d in $CARGO_HOME/registry/src/github.com-*/tikv-jemalloc-sys-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}
