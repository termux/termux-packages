TERMUX_PKG_HOMEPAGE=https://github.com/GokuXZI/javago
TERMUX_PKG_DESCRIPTION="Automatic Java compiler and runner for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="GokuXZI"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/GokuXZI/javago/archive/refs/tags/v1.0.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm700 javago $TERMUX_PREFIX/bin/javago
}
