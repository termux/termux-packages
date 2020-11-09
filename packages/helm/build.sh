TERMUX_PKG_HOMEPAGE=https://helm.sh
TERMUX_PKG_DESCRIPTION="Helm helps you manage Kubernetes applications" 
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_SRCURL=https://github.com/helm/helm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3f7178961cb181818a6840651321cd8c87dfaf68099879e985302ace0d36b24 

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
