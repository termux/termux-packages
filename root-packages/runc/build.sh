TERMUX_PKG_HOMEPAGE=https://www.opencontainers.org/
TERMUX_PKG_DESCRIPTION="A tool for spawning and running containers according to the OCI specification"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.0-rc8
TERMUX_PKG_SRCURL=https://github.com/opencontainers/runc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efe4ff9bbe49b19074346d65c914d809c0a3e90d062ea9619fe240f931f0b700
TERMUX_PKG_DEPENDS="libseccomp"

termux_step_make() {
    termux_setup_golang

    export GOPATH="${PWD}/go"

    mkdir -p "${GOPATH}/src/github.com/opencontainers"
    ln -sf "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/opencontainers/runc"

    cd "${GOPATH}/src/github.com/opencontainers/runc" && make
}

termux_step_make_install() {
    cd "${GOPATH}/src/github.com/opencontainers/runc"
    install -Dm755 runc "${TERMUX_PREFIX}/bin/runc"
}
