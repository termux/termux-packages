TERMUX_PKG_HOMEPAGE=https://github.com/Michael-F-Bryan/mdbook-epub
TERMUX_PKG_DESCRIPTION="An EPUB renderer for mdbook"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.14
TERMUX_PKG_SRCURL=https://github.com/Michael-F-Bryan/mdbook-epub/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2cf2c38c50a3eb476c14854f395ce3423ec58ddc310699d747df5a6f37f6cf1
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_PKG_BUILDER_DIR/mdbook-src-renderer-html_handlebars-helpers-navigation.rs.diff
	local d
	for d in $CARGO_HOME/registry/src/github.com-*/mdbook-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-epub
}
