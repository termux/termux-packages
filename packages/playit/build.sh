TERMUX_PKG_HOMEPAGE="https://playit.gg"
TERMUX_PKG_DESCRIPTION="playit is a global proxy that allows anyone to host a server without port forwarding."
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@nisheri-ascar"
TERMUX_PKG_VERSION="0.15.11"
TERMUX_PKG_SRCURL=https://github.com/playit-cloud/playit-agent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ccdc750df5ebf208d9454fc431b9273321de87b0deca1c01b86a2428ef17daa8
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
		termux_setup_rust
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/playit-cli
}

