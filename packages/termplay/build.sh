TERMUX_PKG_HOMEPAGE=https://gitlab.com/jD91mZM2/termplay
TERMUX_PKG_DESCRIPTION="Plays an image/video in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.6
TERMUX_PKG_SRCURL=https://gitlab.com/jD91mZM2/termplay/-/archive/v${TERMUX_PKG_VERSION}/termplay-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fba29bf75640c698079b22eeb05e3fdc81c8abc7b232bd9b6752f267aa5405e0
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libsixel"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release \
		--features bin
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/termplay
}
