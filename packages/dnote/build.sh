TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="A simple command line notebook for programmers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION="1:0.16.0"
TERMUX_PKG_SRCURL="https://github.com/dnote/dnote/archive/refs/tags/cli-v${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=fb63c6099ca441a2027a9e8ae2a3c38376e5c0950bef9e8028b96ca2b8b6427f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="cli-v\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS=dnote-client
TERMUX_PKG_REPLACES=dnote-client

termux_step_pre_configure() {
	termux_setup_golang
	go mod download
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"
	go build -o dnote -ldflags "-X main.versionTag=${TERMUX_PKG_VERSION:2}" -tags fts5 pkg/cli/main.go
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/dnote $TERMUX_PREFIX/bin/dnote
	install -Dm600 "$TERMUX_PKG_SRCDIR"/pkg/cli/dnote-completion.bash \
		"$TERMUX_PREFIX"/share/bash-completion/completions/dnote
	install -Dm600 "$TERMUX_PKG_SRCDIR"/pkg/cli/dnote-completion.zsh \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_dnote
}
