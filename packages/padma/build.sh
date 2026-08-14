TERMUX_PKG_HOMEPAGE=https://github.com/OfficialBiohub/padma-lang
TERMUX_PKG_DESCRIPTION="Padma Bangla-English programming language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="OfficialBiohub"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SRCURL="https://github.com/OfficialBiohub/padma-lang/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=06b90b992e59a5304753c675fd21f78a0c63d1ca615bb43cb26b8e3d7806683a
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="rust"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    termux_setup_rust
    cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release --locked
}

termux_step_make_install() {
    install -Dm755 target/release/padma "$TERMUX_PREFIX/bin/padma"
}
