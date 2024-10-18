TERMUX_PKG_HOMEPAGE="https://pdfcpu.io"
TERMUX_PKG_DESCRIPTION="A PDF processor written in Go"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_SRCURL="https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=965624c0d714d8ae2c3db06874ae37973d37bb7815ea4eeec7c761ffc6143a1a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	cd "${TERMUX_PKG_SRCDIR}/cmd/pdfcpu"
	go build
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_SRCDIR}/cmd/pdfcpu/pdfcpu" \
		"$TERMUX_PREFIX/bin/"
}
