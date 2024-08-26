TERMUX_PKG_HOMEPAGE=https://github.com/sachaos/viddy
TERMUX_PKG_DESCRIPTION="A modern watch command"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.2"
TERMUX_PKG_SRCURL=https://github.com/sachaos/viddy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=065ae0fd3e5e5b822932a72e62c886ed287bf7d12ba69ce3b1a02071be772bd1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/viddy
}
