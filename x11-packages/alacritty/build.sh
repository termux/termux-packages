TERMUX_PKG_HOMEPAGE=https://github.com/alacritty/alacritty
TERMUX_PKG_DESCRIPTION="A modern terminal emulator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SRCURL=https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e48d4b10762c2707bb17fd8f89bd98f0dcccc450d223cade706fdd9cfaefb308
TERMUX_PKG_DEPENDS="fontconfig, freetype, libxcb, libxkbcommon"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_cmake

	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target $CARGO_TARGET_NAME

	local d
	for d in $CARGO_HOME/registry/src/github.com-*/android_glue-*; do
		patch --silent -p1 -d ${d} < "$TERMUX_PKG_BUILDER_DIR/android_glue.diff" || :
	done
	for d in $CARGO_HOME/registry/src/github.com-*/glutin-*; do
		patch --silent -p1 -d ${d} < "$TERMUX_PKG_BUILDER_DIR/glutin.diff" || :
	done
	for d in $CARGO_HOME/registry/src/github.com-*/glutin_egl_sys-*; do
		patch --silent -p1 -d ${d} < "$TERMUX_PKG_BUILDER_DIR/glutin_egl_sys.diff" || :
	done
	for d in $CARGO_HOME/registry/src/github.com-*/glutin_glx_sys-*; do
		patch --silent -p1 -d ${d} < "$TERMUX_PKG_BUILDER_DIR/glutin_glx_sys.diff" || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/alacritty
}
