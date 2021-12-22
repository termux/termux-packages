TERMUX_PKG_HOMEPAGE=https://github.com/int128/kubelogin
TERMUX_PKG_DESCRIPTION="A kubectl plugin for Kubernetes OpenID Connect (OIDC) authentication"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Steeve Chailloux"
TERMUX_PKG_VERSION=1.25.0
TERMUX_PKG_SRCURL=https://github.com/int128/kubelogin/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9c1a2d3415eb259783279e9a18f6e09c4bf2aff338e4ab9efdce3a35ad03a84e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
        termux_setup_golang
        cd "$TERMUX_PKG_SRCDIR"
        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/int128"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/int128/kubelogin"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/int128/kubelogin"

        go build -o kubelogin -ldflags "-X main.version=${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/int128/kubelogin/kubelogin \
                 $TERMUX_PREFIX/bin/kubectl-oidc_login
}
