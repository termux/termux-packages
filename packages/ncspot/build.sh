TERMUX_PKG_HOMEPAGE=https://github.com/hrkfdn/ncspot
TERMUX_PKG_DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="BSD-2-Clause"
TERMUX_PKG_VERSION=0.9.3
TERMUX_PKG_SRCURL=https://github.com/hrkfdn/ncspot/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ed873d007ce356e8c6eed56226533b686682a98d2a37487668416539d4e10e78
TERMUX_INSTALL_DEPS=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=" pulseaudio, x11-repo, python, rust, pulseaudio, dbus, ncurses, libxcb, openssl"
termux_step_make_install() {
	termux_setup_rust
	cd ${TERMUX_PKG_SRCDIR} && cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/ncspot
}

