TERMUX_PKG_HOMEPAGE=https://k9scli.io
TERMUX_PKG_DESCRIPTION="Kubernetes CLI To Manage Your Clusters In Style!"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="0.25.20"
TERMUX_PKG_SRCURL=https://github.com/derailed/k9s/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2c3c40a37f665567772a99ca391f5ca9745c023cea7a0fdfe5919a72ee75d38f
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
        termux_setup_golang
        cd "$TERMUX_PKG_SRCDIR"
        mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed"
        cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s"
        cd "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s"

        go get -d -v
        go build
}

termux_step_make_install() {
        install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s/k9s \
                 $TERMUX_PREFIX/bin/k9s
}
