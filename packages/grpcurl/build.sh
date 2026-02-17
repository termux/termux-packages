TERMUX_PKG_HOMEPAGE=https://github.com/fullstorydev/grpcurl
TERMUX_PKG_DESCRIPTION="Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.3"
TERMUX_PKG_SRCURL="https://github.com/fullstorydev/grpcurl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SHA256=bb555087f279af156159c86d4d3d5dd3f2991129e4cd6b09114e6851a679340d

termux_step_make() {
	termux_setup_golang
	export GOPATH="${TERMUX_PKG_BUILDDIR}"

	cd "${TERMUX_PKG_SRCDIR}"
	go build ./cmd/grpcurl
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" \
		"${TERMUX_PKG_SRCDIR}/grpcurl"
}
