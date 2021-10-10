TERMUX_PKG_HOMEPAGE=https://restic.net/
TERMUX_PKG_DESCRIPTION="Restic's REST backend API server"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/restic/rest-server/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d109cf9e9c3f36c9c8eb6d4a2bd530c5dfcd62b11687d93034e2edc0fdecf479
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	_GOARCH="${GOARCH}"
	unset GOOS GOARCH
	go run build.go \
		--enable-cgo \
		--goos android \
		--goarch "${_GOARCH}"
}

termux_step_make_install() {
	install -Dm755 rest-server "${TERMUX_PREFIX}/bin/rest-server"
}
