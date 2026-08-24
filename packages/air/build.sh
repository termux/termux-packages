TERMUX_PKG_HOMEPAGE=https://github.com/air-verse/air
TERMUX_PKG_DESCRIPTION="Live reload for Go apps - rebuilds and restarts your binary on file change"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=1.67.4
TERMUX_PKG_SRCURL=https://github.com/air-verse/air/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d74de50458f4f2cd744bb08a1acf84dbbcc99138ea0682176568f9a381a81887
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w -X main.version=${TERMUX_PKG_VERSION}" \
		-o air \
		.
}

termux_step_make_install() {
	install -Dm755 air "$TERMUX_PREFIX/bin/air"
	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/air/README.md"
}
