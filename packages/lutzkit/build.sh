TERMUX_PKG_HOMEPAGE=https://github.com/padukalutz/lutzkit
TERMUX_PKG_DESCRIPTION="Developer CLI and project generator"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="padukalutz"
TERMUX_PKG_VERSION="0.1.4"
TERMUX_PKG_SRCURL=https://github.com/padukalutz/lutzkit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
        termux_setup_golang

        go build \
                -trimpath \
                -mod=readonly \
                -o lutzkit \
                ./cmd/lutzkit
}

termux_step_make_install() {
        install -Dm755 lutzkit "$TERMUX_PREFIX/bin/lutzkit"
}
