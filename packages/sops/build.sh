TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/sops
TERMUX_PKG_DESCRIPTION="Simple and flexible tool for managing secrets"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Philipp Schmitt @pschmitt"
TERMUX_PKG_VERSION="3.8.0"
TERMUX_PKG_SRCURL="https://github.com/mozilla/sops/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=14fa25f2d6177c5444934612398426a8de3caf59348eae8cc228291cf750288a
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	termux_setup_golang

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/go.mozilla.org"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/go.mozilla.org/sops"
	cd "${GOPATH}/src/go.mozilla.org/sops" || return 9
	go get -d -v
	make install

	install -Dm700 "${GOPATH}/bin/"*/sops "${TERMUX_PREFIX}/bin/sops"
}
