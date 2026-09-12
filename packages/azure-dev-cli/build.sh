TERMUX_PKG_HOMEPAGE="https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/"
TERMUX_PKG_DESCRIPTION="Developer-centric CLI for creating, provisioning and deploying Azure applications (azd)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.34.0"
TERMUX_PKG_SRCURL="https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8d53317656216cfb61444a62de75c02e031240f6ce0b749542031e75edd06447
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	# azd panics at startup unless internal.Version exactly matches
	# "<semver> (commit <full 40-char commit hash>)" (see cli/azd/internal/version.go).
	# Resolved dynamically so it stays correct across version bumps.
	local _commit
	_commit="$(git ls-remote "https://github.com/Azure/azure-dev.git" \
		"refs/tags/azure-dev-cli_${TERMUX_PKG_VERSION}" | cut -f1)"
	if [[ -z "$_commit" ]]; then
		termux_error_exit "Could not resolve commit hash for tag azure-dev-cli_${TERMUX_PKG_VERSION}"
	fi

	cd "$TERMUX_PKG_SRCDIR/cli/azd"
	go build \
		-trimpath \
		-ldflags="-s -w -X 'github.com/azure/azure-dev/cli/azd/internal.Version=${TERMUX_PKG_VERSION} (commit ${_commit})'" \
		-o azd \
		.
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR/cli/azd"

	install -Dm755 azd "$TERMUX_PREFIX/bin/azd"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/azd"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_azd"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/azd.fish"
}
