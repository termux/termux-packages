TERMUX_PKG_HOMEPAGE=https://buf.build
TERMUX_PKG_DESCRIPTION="A new way of working with Protocol Buffers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.47.2"
TERMUX_PKG_SRCURL=https://github.com/bufbuild/buf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d20b70d863e23f8484321f6b70474325eb1dda3a126182d5c54d3ed5c0640e49
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
