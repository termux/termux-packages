TERMUX_PKG_HOMEPAGE="https://github.com/ismaelgv/rnr"
TERMUX_PKG_DESCRIPTION="Batch rename files and directories using regular expression (rust)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="0.4.2"
TERMUX_PKG_SRCURL="https://github.com/ismaelgv/rnr/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cde8e5366552263300e60133b82f6a3868aeced2fe83abc91c2168085dff0998
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --locked
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rnr
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.* CHANGELOG*
}
