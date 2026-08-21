TERMUX_PKG_HOMEPAGE=https://github.com/frostre1997/prep
TERMUX_PKG_DESCRIPTION="Repository health auditor and build error parser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="frostre1997 <n9043395@gmail.com>"
TERMUX_PKG_VERSION="0.100.0"
TERMUX_PKG_SRCURL=https://github.com/frostre1997/prep/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
    cargo build --release --target $CARGO_TARGET_NAME
}

termux_step_make_install() {
    install -Dm700 target/${CARGO_TARGET_NAME}/release/prep $TERMUX_PREFIX/bin/prep
}
