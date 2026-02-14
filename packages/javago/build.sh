TERMUX_PKG_HOMEPAGE=https://github.com/GokuXZI/javago
TERMUX_PKG_DESCRIPTION="Automatic Java compiler and runner for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="GokuXZI"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/GokuXZI/javago/archive/refs/tags/v1.0.0.tar.gz
TERMUX_PKG_SHA256=2d158eab159a067c212c4f208517ae7f5622c3a120993b00ee35f76e5a9ec8c5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openjdk"

termux_step_make_install() {
    install -Dm700 javago $TERMUX_PREFIX/bin/javago
}
