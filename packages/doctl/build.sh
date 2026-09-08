TERMUX_PKG_HOMEPAGE=https://github.com/digitalocean/doctl
TERMUX_PKG_DESCRIPTION="The official command line interface for the DigitalOcean API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=1.168.0
TERMUX_PKG_SRCURL=https://github.com/digitalocean/doctl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5c7c045d7f14a8f4e7249e07a5302520f5b3130137360047dd7964246527905
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	local IFS=.
	local -a ver=($TERMUX_PKG_VERSION)
	go build \
		-mod=vendor \
		-trimpath \
		-ldflags="-s -w \
			-X github.com/digitalocean/doctl.Major=${ver[0]} \
			-X github.com/digitalocean/doctl.Minor=${ver[1]} \
			-X github.com/digitalocean/doctl.Patch=${ver[2]} \
			-X github.com/digitalocean/doctl.Label=release" \
		-o doctl \
		./cmd/doctl
}

termux_step_make_install() {
	install -Dm755 doctl "$TERMUX_PREFIX/bin/doctl"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run ./cmd/doctl completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/doctl"
	go run ./cmd/doctl completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_doctl"
	go run ./cmd/doctl completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/doctl.fish"
}
