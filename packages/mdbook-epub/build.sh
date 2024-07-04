TERMUX_PKG_HOMEPAGE=https://github.com/Michael-F-Bryan/mdbook-epub
TERMUX_PKG_DESCRIPTION="An EPUB renderer for mdbook"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.37"
TERMUX_PKG_SRCURL=https://github.com/Michael-F-Bryan/mdbook-epub/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=028702150826d7f2ed13d0892f5cbf44d7dbf4854a1b16df35a4da5658e59446
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_PKG_BUILDER_DIR/mdbook-src-renderer-html_handlebars-helpers-navigation.rs.diff
	local d
	for d in $CARGO_HOME/registry/src/*/mdbook-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-epub
}
