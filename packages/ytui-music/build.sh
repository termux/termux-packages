TERMUX_PKG_HOMEPAGE=https://github.com/sudipghimire533/ytui-music
TERMUX_PKG_DESCRIPTION="Youtube client in terminal for music"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.0-beta
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/sudipghimire533/ytui-music/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43deb6b3cb9eb836b7122ac2542106f46519f240f99a0af67eecdfa5b200cca7
TERMUX_PKG_DEPENDS="libsqlite, mpv, openssl, python-yt-dlp"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib

	TERMUX_PKG_SRCDIR+="/front-end"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"

	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ../target/${CARGO_TARGET_NAME}/release/ytui_music
}
