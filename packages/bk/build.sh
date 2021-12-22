TERMUX_PKG_HOMEPAGE=https://github.com/aeosynth/bk
TERMUX_PKG_DESCRIPTION="A terminal EPUB reader"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.3
# Whenever the next release happens, we can change to git release tarball.
_COMMIT=61beded518e759884d72732a068744935c11ea6f
TERMUX_PKG_SRCURL=https://github.com/aeosynth/bk/archive/$_COMMIT.zip
TERMUX_PKG_SHA256=c8d738eaf56684fcaeda9c46549e0f024801805d82cf31542a35c007faf07085
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/bk
}
