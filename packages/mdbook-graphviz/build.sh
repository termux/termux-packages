TERMUX_PKG_HOMEPAGE=https://github.com/dylanowen/mdbook-graphviz
TERMUX_PKG_DESCRIPTION="mdbook preprocessor to add graphviz support"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.7"
TERMUX_PKG_SRCURL=https://github.com/dylanowen/mdbook-graphviz/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eab1204556b55d2dd845fdf7d03525204c8bcdb69cf93e5649b491895d485198
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="graphviz"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-graphviz
}
