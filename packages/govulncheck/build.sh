TERMUX_PKG_HOMEPAGE=https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck
TERMUX_PKG_DESCRIPTION="Reports known vulnerabilities affecting Go code"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SRCURL=https://github.com/golang/vuln/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fb7f0204b7e039f550d8938b714c5218d870694895585e0e19b2c0c4700e4c7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# This repo (golang.org/x/vuln) contains the govulncheck CLI along with
# internal packages for the Go vulnerability database client; we only
# build and package the govulncheck subcommand out of it.
termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o govulncheck \
		./cmd/govulncheck
}

termux_step_make_install() {
	install -Dm755 govulncheck "$TERMUX_PREFIX/bin/govulncheck"
}
