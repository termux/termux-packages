TERMUX_PKG_HOMEPAGE=https://github.com/elkowar/eww
TERMUX_PKG_DESCRIPTION="ElKowars wacky widgets"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL=git+https://github.com/elkowar/eww
TERMUX_PKG_DEPENDS="glib, gtk3, pango, gdk-pixbuf, libcairo"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/eww
}
