TERMUX_PKG_HOMEPAGE="https://github.com/exercism/cli/"
TERMUX_PKG_DESCRIPTION="A Go based command line tool for exercism.io"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.4"
TERMUX_PKG_SRCURL="https://github.com/exercism/cli/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=58dcd1a62552466b6fa3d3ad62747b1cfeafae5fca3b511c08f5efa9af22539c
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR
	cd $TERMUX_PKG_SRCDIR/exercism
	go build
}

termux_step_post_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR/exercism/exercism" \
		"$TERMUX_PREFIX/bin/exercism"

	# shell completions
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell/exercism_completion.bash" \
		"$TERMUX_PREFIX"/share/bash-completion/completions/exercism
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell/exercism_completion.zsh" \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_exercism
	install -Dm644 "$TERMUX_PKG_SRCDIR/shell/exercism.fish" \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/exercism.fish
}
