TERMUX_PKG_HOMEPAGE=https://buf.build
TERMUX_PKG_DESCRIPTION="A new way of working with Protocol Buffers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_SRCURL=https://github.com/bufbuild/buf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=76c1c33fc0e9b64374fe319283d0180233a0992f2d09d3e7864e1f4112e9f43d
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
        termux_setup_golang
        cd "$TERMUX_PKG_SRCDIR"
        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf"

        go mod download 
        go build -ldflags "-s -w" -trimpath ./cmd/buf
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf/buf \
                 $TERMUX_PREFIX/bin/buf
}
