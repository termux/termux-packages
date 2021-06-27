TERMUX_PKG_HOMEPAGE="https://lib.rs/cavif"
TERMUX_PKG_DESCRIPTION="Encoder/converter for AVIF images. Based on rav1e and avif-serialize."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_SRCURL=https://github.com/kornelski/cavif-rs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ee6198b2dc0843cddaeeaece964d2615ca84997265b72ff69ca3ef9e18ddf23
TERMUX_PKG_BUILD_DEPENDS="nasm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	termux_setup_rust
}

termux_step_make(){
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_post_make_install(){
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/cavif
}
