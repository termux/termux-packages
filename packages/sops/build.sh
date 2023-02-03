TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/sops
TERMUX_PKG_DESCRIPTION="Simple and flexible tool for managing secrets"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Philipp Schmitt @pschmitt"
TERMUX_PKG_VERSION="3.7.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/mozilla/sops/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0e563f0c01c011ba52dd38602ac3ab0d4378f01edfa83063a00102587410ac38
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
