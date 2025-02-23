TERMUX_PKG_HOMEPAGE=https://github.com/int128/kubelogin
TERMUX_PKG_DESCRIPTION="A kubectl plugin for Kubernetes OpenID Connect (OIDC) authentication"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.32.2"
TERMUX_PKG_SRCURL=https://github.com/int128/kubelogin/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ea8abeb811d0c6b243a56c9eb19bea8c8e587fe4899d58df83893aed39e20be
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
