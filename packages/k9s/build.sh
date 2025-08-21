TERMUX_PKG_HOMEPAGE=https://k9scli.io
TERMUX_PKG_DESCRIPTION="Kubernetes CLI To Manage Your Clusters In Style!"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="0.50.9"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/derailed/k9s/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7496cfc6da6da5d91ef2ad5ea61eae15186effabb77adf904c896213ca6ff810
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	local GOPKG="github.com/derailed/k9s"
	local GOLDFLAGS="-w -s -X ${GOPKG}/cmd.version=${TERMUX_PKG_VERSION} -X ${GOPKG}/cmd.commit=${TERMUX_PKG_VERSION}"
	cd "$TERMUX_PKG_SRCDIR"
	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s"

	go get -d -v
	go build -ldflags "$GOLDFLAGS"
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/derailed/k9s/k9s \
		$TERMUX_PREFIX/bin/k9s
}
