TERMUX_PKG_HOMEPAGE=https://docs.iyear.me/tdl/
TERMUX_PKG_DESCRIPTION="Telegram downloader/tools written in Golang"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a0bafa3e7054f05305f145e87c5f31827c1f36c71286080e573ae7d5a1df64f2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	read -r commit_hash commit_date < <(
		curl -s "https://api.github.com/repos/iyear/tdl/commits/v${TERMUX_PKG_VERSION}" \
			| jq -r '[.sha, .commit.committer.date] | "\(.[0][0:7]) \(.[1])"'
	)
	local _ldflags="-s -w -X github.com/iyear/tdl/pkg/consts.Version=${TERMUX_PKG_VERSION}"
	_ldflags+=" -X github.com/iyear/tdl/pkg/consts.Commit=${commit_hash}"
	_ldflags+=" -X github.com/iyear/tdl/pkg/consts.CommitDate=${commit_date}"
	go build --ldflags="$_ldflags"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" tdl
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"

	# borrowed from packages/gh
	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion  zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
}
