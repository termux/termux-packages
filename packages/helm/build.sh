TERMUX_PKG_HOMEPAGE=https://helm.sh
TERMUX_PKG_DESCRIPTION="Helm helps you manage Kubernetes applications" 
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/helm/helm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=edfde8784f25444a02306777e30d9ebd7eefc86cbd06ed78e8e287424d50a80b

termux_step_make() {
        termux_setup_golang 
        cd "$TERMUX_PKG_SRCDIR"
        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/helm"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm"

        make
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/helm/helm/bin/helm \
                 $TERMUX_PREFIX/bin/helm
}
