TERMUX_PKG_HOMEPAGE=https://github.com/PepeDiedrich/war-dodge
TERMUX_PKG_DESCRIPTION="Location-aware monitor for U.S. State Department travel advisory changes"
TERMUX_PKG_VERSION=0.1.4
TERMUX_PKG_SRCURL=https://github.com/PepeDiedrich/war-dodge/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68deaf92007713c3e039f0d40206b19e3786e54b787815f04bc05ccc93d1fda2
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
