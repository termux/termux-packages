TERMUX_PKG_HOMEPAGE=https://github.com/orf/gping
TERMUX_PKG_DESCRIPTION="Ping, but with a graph"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_SRCURL=https://github.com/orf/gping/archive/refs/tags/gping-v$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=647ac4643c0467a6ba0717f12e1813968554beb7c2709fa2d95941425d2abdc0
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cd gping
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	cd ..
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/gping
}
