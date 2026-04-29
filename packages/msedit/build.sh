TERMUX_PKG_HOMEPAGE="https://github.com/microsoft/edit"
TERMUX_PKG_DESCRIPTION="A simple editor for simple needs (Microsoft Edit)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL="https://github.com/microsoft/edit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f35da309c5f3d92b10e5c4b2267e4d5e29d809b2aa460e80326b11f7feba72a5
TERMUX_PKG_DEPENDS="libicu"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	# Allow nightly features
	export RUSTC_BOOTSTRAP=1
	cargo build --release \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/edit" "$TERMUX_PREFIX/bin/msedit"
	ln -sf "./msedit" "$TERMUX_PREFIX/bin/edit" # and symlink bin/edit
	install -Dm644 "$TERMUX_PKG_SRCDIR/assets/manpage/edit.1" "$TERMUX_PREFIX/share/man/man1/msedit.1"
	ln -sf "./msedit.1.gz" "$TERMUX_PREFIX/share/man/man1/edit.1.gz" # and symlink man1/edit.1.gz
}
