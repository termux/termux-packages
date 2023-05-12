TERMUX_PKG_HOMEPAGE=https://github.com/kaegi/alass
TERMUX_PKG_DESCRIPTION="Automatic Language-Agnostic Subtitle Synchronization"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/kaegi/alass/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ce88f92c7a427b623edcabb1b64e80be70cca2777f3da4b96702820a6cdf1e26
TERMUX_PKG_DEPENDS="ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f Makefile
}

termux_step_make_install() {
	termux_setup_rust
	cargo install \
		--jobs $TERMUX_MAKE_PROCESSES \
		--path alass-cli \
		--force \
		--locked \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	# https://github.com/rust-lang/cargo/issues/3316:
	rm -f $TERMUX_PREFIX/.crates.toml
	rm -f $TERMUX_PREFIX/.crates2.json
}

termux_step_post_make_install() {
	install -Dm644 LICENSE "$TERMUX_PREFIX/share/licenses/alass/LICENSE"
}
