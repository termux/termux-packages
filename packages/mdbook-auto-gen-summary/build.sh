TERMUX_PKG_HOMEPAGE=https://github.com/cococolanosugar/mdbook-auto-gen-summary
TERMUX_PKG_DESCRIPTION="A preprocessor and cli tool for mdbook to auto generate summary"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=a8e1d8edba05c52d927880a5fe2b97180441c955
TERMUX_PKG_VERSION=0.1.10
TERMUX_PKG_SRCURL=https://github.com/cococolanosugar/mdbook-auto-gen-summary.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/termux/termux-packages/issues/12824
TERMUX_RUST_VERSION=1.63.0

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local ver=$(sed -En 's/^version = "([^"]+)".*/\1/p' Cargo.toml)
	if [ "${ver}" != "${TERMUX_PKG_VERSION#*:}" ]; then
		termux_error_exit "Version string '$TERMUX_PKG_VERSION' does not seem to be correct."
	fi
}

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_PKG_BUILDER_DIR/filetime-src-unix-utimes.rs.diff
	local d
	for d in $CARGO_HOME/registry/src/github.com-*/filetime-*; do
		patch --silent -p1 -d ${d} < ${_patch} || :
	done
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-auto-gen-summary
}
