TERMUX_PKG_HOMEPAGE="https://pdfcpu.io"
TERMUX_PKG_DESCRIPTION="A PDF processor written in Go"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/pdfcpu/pdfcpu/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=16e6e4fbcf809f9d737d8931c267220e5e4cb00fbce793eeaa4501193b954c55
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
