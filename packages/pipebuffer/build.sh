TERMUX_PKG_HOMEPAGE=https://github.com/tfenne/pipebuffer
TERMUX_PKG_DESCRIPTION="Arbitrary-sized in-memory buffer between pipelined programs (non-blocking mbuffer analogue for pipeline)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.git20211120"
TERMUX_PKG_SRCURL=https://github.com/tfenne/pipebuffer/archive/9af1e18b38b9a62b054047e4131d4077cce101ae.tar.gz
TERMUX_PKG_SHA256=cc73135fa4f3bec90ab762271122dd7671bfc9f664a9c4bda9734b661372ac6d
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -vDm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/pipebuffer
	mkdir -vp $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	install -vpm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
