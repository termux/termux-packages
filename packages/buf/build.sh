TERMUX_PKG_HOMEPAGE=https://buf.build
TERMUX_PKG_DESCRIPTION="A new way of working with Protocol Buffers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17.0"
TERMUX_PKG_SRCURL=https://github.com/bufbuild/buf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e618146ec56dc874213de8f15f472629d670c7d6dca3de3544bf046ed020c03
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ENABLE_CLANG16_PORTING=false

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
