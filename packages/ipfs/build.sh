TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=0.4.15
TERMUX_PKG_SRCURL=https://github.com/ipfs/go-ipfs/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b7e58e86e6abaf97687a566747376f13d8b5dde8b51033e3ff17f0d7fa8d5232

termux_step_make() {
    termux_setup_golang

    export GOPATH=${TERMUX_PKG_BUILDDIR}
    export GOARCH=${TERMUX_ARCH}

    if [ "${TERMUX_ARCH}" = "aarch64" ]; then
        export GOARCH="arm64"
    elif [ "${TERMUX_ARCH}" = "i686" ]; then
        export GOARCH="386"
    elif [ "${TERMUX_ARCH}" = "x86_64" ]; then
        export GOARCH="amd64"
    fi

    mkdir -p "${GOPATH}/src/github.com/ipfs"
    cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ipfs/go-ipfs"
    cd "${GOPATH}/src/github.com/ipfs/go-ipfs"

    make build
}

termux_step_make_install() {
    mkdir -p "${TERMUX_PREFIX}/bin"
    cp -f "${TERMUX_PKG_BUILDDIR}/src/github.com/ipfs/go-ipfs/cmd/ipfs/ipfs" "${TERMUX_PREFIX}/bin/"
}
