TERMUX_PKG_HOMEPAGE=https://github.com/PepeDiedrich/war-dodge
TERMUX_PKG_DESCRIPTION="Location-aware monitor for U.S. State Department travel advisory changes"
TERMUX_PKG_VERSION=0.1.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/PepeDiedrich/war-dodge/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=beab8aaaa6d87dd7f4ee6a1d219a91ef9afe91a379f66332a76794c92abcdce3
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@PepeDiedrich"
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    termux_setup_rust
}

termux_step_make() {
    cargo build --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
    install -Dm755 "target/${CARGO_TARGET_NAME}/release/war-dodger" \
        "${TERMUX_PREFIX}/bin/war-dodger"
}
