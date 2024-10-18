TERMUX_PKG_HOMEPAGE=https://github.com/dylanowen/mdbook-graphviz
TERMUX_PKG_DESCRIPTION="mdbook preprocessor to add graphviz support"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dylanowen/mdbook-graphviz/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=76b0880f74e2a9a2d271f6810181e888fc108bd1184589d115bfa6c491ea964b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="graphviz"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-graphviz
}
