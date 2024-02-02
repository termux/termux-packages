TERMUX_PKG_HOMEPAGE=https://github.com/sigoden/aichat
TERMUX_PKG_DESCRIPTION="A powerful chatgpt cli"
TERMUX_PKG_LICENSE="Apache-2.0,MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE,LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL=https://github.com/sigoden/aichat/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4713e650f0898b927c1d61f61c9b2871612956c416c8b45a3e213b69f7455996
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# This package contains makefiles to run the tests. So, we need to override build steps.
termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/aichat
}
