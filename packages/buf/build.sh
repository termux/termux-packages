TERMUX_PKG_HOMEPAGE=https://buf.build
TERMUX_PKG_DESCRIPTION="A new way of working with Protocol Buffers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.65.0"
TERMUX_PKG_SRCURL=https://github.com/bufbuild/buf/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=386b49aaa2d763fa5d73ff2eb7e88fff89c6b1feacdc6b5e1badc1a173d79fbf
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"
	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf"

	go mod download
	go build -ldflags "-s -w" -trimpath ./cmd/buf
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/bufbuild/buf/buf \
		$TERMUX_PREFIX/bin/buf
}
