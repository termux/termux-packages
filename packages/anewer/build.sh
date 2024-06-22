TERMUX_PKG_HOMEPAGE="https://github.com/ysf/anewer"
TERMUX_PKG_DESCRIPTION="Append lines from stdin to a file if these lines do not present in that file (aHash-based uniq)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="0.1.6"
TERMUX_PKG_SRCURL="https://github.com/ysf/anewer/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=0f7d85dcba7cee291f63b8475a74806d385be768a43c2bf039fc32198026d918
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --locked
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/anewer
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
