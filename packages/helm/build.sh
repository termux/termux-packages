TERMUX_PKG_HOMEPAGE=https://helm.sh
TERMUX_PKG_DESCRIPTION="Helm helps you manage Kubernetes applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.18.2"
TERMUX_PKG_SRCURL=https://github.com/helm/helm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ac3e04eef368096fcd3150dc811e028a5c1320a5733ab86b3105724cc45a735
TERMUX_PKG_AUTO_UPDATE=true

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
