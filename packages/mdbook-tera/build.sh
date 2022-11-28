TERMUX_PKG_HOMEPAGE=https://github.com/avitex/mdbook-tera
TERMUX_PKG_DESCRIPTION="Tera preprocessor for mdBook"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_SRCURL=https://github.com/avitex/mdbook-tera/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=676477d95fa0b8f23962ccf52aa4b394d0ebac0044d33f9f11d995d8d3b98d3d
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
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-tera
}
