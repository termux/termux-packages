TERMUX_PKG_HOMEPAGE=https://pkg.go.dev/golang.org/x/tools/cmd/goimports
TERMUX_PKG_DESCRIPTION="Updates Go import lines, adding missing ones and removing unreferenced ones"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=0.49.0
TERMUX_PKG_SRCURL=https://github.com/golang/tools/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df7f087706730d85ced76f5f2e3d1a51703de3beb305acc72d1170d405f5a21e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="^v\K[0-9]+\.[0-9]+\.[0-9]+$"
TERMUX_PKG_BUILD_IN_SRC=true

# This whole repo (golang.org/x/tools) is a monorepo of many Go dev tools;
# we only build and package the goimports subcommand out of it.
termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o goimports \
		./cmd/goimports
}

termux_step_make_install() {
	install -Dm755 goimports "$TERMUX_PREFIX/bin/goimports"
}
