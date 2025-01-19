TERMUX_PKG_HOMEPAGE=https://tailscale.com/
TERMUX_PKG_DESCRIPTION="Mesh VPN based on WireGuard"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.78.3"
TERMUX_PKG_SRCURL=https://github.com/tailscale/tailscale/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bac059152e3fa8ab379ee5ec7a03940114e7ac65c6e1baea4f840f6fadd17d57
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
# The actual service script is being added in termux_step_post_massage()
TERMUX_PKG_SERVICE_SCRIPT=('tailscaled' '{{placeholder}}')
termux_step_make() {
	ldflags="\
		-linkmode=external \
		-X tailscale.com/version.longStamp=${TERMUX_PKG_VERSION} \
		-X tailscale.com/version.shortStamp=$(cut -d+ -f1 <<< "${TERMUX_PKG_VERSION}") \
		-X tailscale.com/version.gitCommitStamp=$( \
		git ls-remote --tags https://github.com/tailscale/tailscale \
		| grep -oE ".*${TERMUX_PKG_VERSION}$" \
		| cut -f1)"

	termux_setup_golang
	for cmd in ./cmd/tailscale{,d}; do
		go build \
			-v \
			-tags xversion \
			-ldflags "$ldflags" \
			"$cmd"
	done
}

termux_step_make_install() {
	# This approach is copied from packages/gh/build.sh
	# In this case it lets us pre-build the completions
	# instead of generating them at install time.
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run ./cmd/tailscale completion bash | install -Dm644 /dev/stdin "${TERMUX_PREFIX}/usr/share/bash-completion/completions/tailscale"
	go run ./cmd/tailscale completion fish | install -Dm644 /dev/stdin "${TERMUX_PREFIX}/usr/share/fish/vendor_completions.d/tailscale.fish"
	go run ./cmd/tailscale completion  zsh | install -Dm644 /dev/stdin "${TERMUX_PREFIX}/usr/share/zsh/site-functions/_tailscale"
	install -Dm700 ./tailscale{,d} "${TERMUX_PREFIX}/bin"
	install -Dm644 cmd/tailscaled/tailscaled.defaults "${TERMUX_PREFIX}/etc/default/tailscaled"
}

termux_step_post_massage() {
	# Replace placeholder service script with actual service script
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR"/tailscaled-sv.sh var/service/tailscaled/run
	sed -i -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" var/service/tailscaled/run
}
