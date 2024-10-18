TERMUX_PKG_HOMEPAGE=https://github.com/hetznercloud/cli
TERMUX_PKG_DESCRIPTION="Hetzner Cloud command line client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.47.0"
TERMUX_PKG_SRCURL=https://github.com/hetznercloud/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f1c15f71cca7c2e725a5047dbd918cc919962930b9681c53402e9c693884894
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	# Below are taken from github.com/hetznercloud/cli@v1.30.1/.goreleaser.yml
	local LD_FLAGS="-s -w -X 'github.com/hetznercloud/cli/internal/version.Version=v${TERMUX_PKG_VERSION}'"
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"
	go build -ldflags "${LD_FLAGS}" -o hcloud  cmd/hcloud/main.go
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin hcloud

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/hcloud
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_hcloud
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/hcloud.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		hcloud completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/hcloud
		hcloud completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_hcloud
		hcloud completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/hcloud.fish
	EOF
}
