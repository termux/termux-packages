TERMUX_PKG_HOMEPAGE=https://restic.net/
TERMUX_PKG_DESCRIPTION="Restic's REST backend API server"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/restic/rest-server/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b3f91d561819ba9bce454505958fcca6d61ecd12e10086954ebfc92ba163ba4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

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
