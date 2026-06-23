TERMUX_PKG_HOMEPAGE=https://github.com/donut-corp/cdomer
TERMUX_PKG_DESCRIPTION="C-family statically typed language that transpiles to C11"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="donut-corp"
TERMUX_PKG_VERSION="0.1.0"
TERMUX_PKG_SRCURL=https://github.com/donut-corp/cdomer/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7c80a5420250c77463e8adc8af43512de31e1ad8bda363b19442d7ac01bf4296
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    cargo build --release
}

termux_step_make_install() {
    install -Dm755 target/release/cdomer "$TERMUX_PREFIX/bin/cdomer"
}
