TERMUX_PKG_HOMEPAGE=https://docs.iyear.me/tdl/
TERMUX_PKG_DESCRIPTION="Telegram downloader/tools written in Golang"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.1"
TERMUX_PKG_SRCURL=https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=dcb6c3d2b41c3712c75dc8f3d69cdc3b932ef9a288e7808df74617af5b487af5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	read commit_hash commit_date <<<"$(
		curl -s "https://api.github.com/repos/iyear/tdl/commits/v${TERMUX_PKG_VERSION}" \
			| jq -r '[.sha, .commit.committer.date] | "\(.[0][0:7]) \(.[1])"'
	)"
	local _ldflags="-s -w -X github.com/iyear/tdl/pkg/consts.Version=${TERMUX_PKG_VERSION}"
	_ldflags+=" -X github.com/iyear/tdl/pkg/consts.Commit=${commit_hash}"
	_ldflags+=" -X github.com/iyear/tdl/pkg/consts.CommitDate=${commit_date}"
	go build --ldflags="$_ldflags"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin tdl

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/tdl
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_tdl
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/tdl.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		tdl completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/tdl"
		tdl completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_tdl"
		tdl completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/tdl.fish"
	EOF
}
