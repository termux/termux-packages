TERMUX_PKG_HOMEPAGE=https://helm.sh
TERMUX_PKG_DESCRIPTION="Helm helps you manage Kubernetes applications" 
TERMUX_PKG_LICENSE="Apache-2.0" 
TERMUX_PKG_MAINTAINER="https://github.com/helm/helm/blob/master/OWNERS" 
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://get.helm.sh/helm-v${TERMUX_PKG_VERSION}-linux-arm64.tar.gz
TERMUX_PKG_SHA256=83cd7a30f4c5ce83eb2afb4974777bf99bb74a5f587c85774d747e3d32e3cb48

termux_step_make() {
        cd "$TERMUX_PKG_SRCDIR"
        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/helm"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm"

        make
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm/helm \
                 $TERMUX_PREFIX/bin/helm
}
