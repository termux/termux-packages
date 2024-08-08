TERMUX_PKG_HOMEPAGE=https://github.com/dylanowen/mdbook-graphviz
TERMUX_PKG_DESCRIPTION="mdbook preprocessor to add graphviz support"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.1"
TERMUX_PKG_SRCURL=https://github.com/dylanowen/mdbook-graphviz/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c5e99e81a9a0431ccec3eb7b507c7c3de76cc08f0ff9eee110ff58f57f09468a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="graphviz"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-graphviz
}
