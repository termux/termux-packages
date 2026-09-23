TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/greed/
TERMUX_PKG_DESCRIPTION="Game where you try to eat as much as possible of the board before munching yourself into a corner"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.2"
TERMUX_PKG_SRCURL=http://www.catb.org/~esr/greed/greed-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4d72075bcf9d951c247bec7cc9d2a64f2319e96784c895835bc880b93430fd7b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --release --target "$CARGO_TARGET_NAME"
	cp "target/$CARGO_TARGET_NAME/release/greed" greed
	make greed.6
}
