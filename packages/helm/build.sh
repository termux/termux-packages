TERMUX_PKG_HOMEPAGE=https://helm.sh
TERMUX_PKG_DESCRIPTION="Helm helps you manage Kubernetes applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.14.1"
TERMUX_PKG_SRCURL=https://github.com/helm/helm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17905b60e375224ac6b00c4edbbefce7b313d2593423c4d565e3fe0438096f1f
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
