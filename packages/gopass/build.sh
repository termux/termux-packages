TERMUX_PKG_HOMEPAGE=https://github.com/gopasspw/gopass
TERMUX_PKG_DESCRIPTION="The slightly more awesome standard unix password manager for teams"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.15.3"
TERMUX_PKG_SRCURL=https://github.com/gopasspw/gopass/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5dec8853ca0b1a8dbe942ba776e0390d6a38d21f9d335d42207116bba7ffd2cb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, gnupg"
TERMUX_PKG_SUGGESTS="termux-api, openssh"

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p ./src
	mkdir -p ./src/github.com/gopasspw
	ln -sf "$TERMUX_PKG_SRCDIR" ./src/github.com/gopasspw/gopass

	rm -f ./src/github.com/gopasspw/gopass/gopass
	make -C ./src/github.com/gopasspw/gopass build CLIPHELPERS="-X github.com/gopasspw/gopass/pkg/clipboard.Helpers=termux-api'"
	install -Dm700 \
		./src/github.com/gopasspw/gopass/gopass \
		"$TERMUX_PREFIX"/bin/gopass
}

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	install -Dm600 gopass.1 -t "$TERMUX_PREFIX/share/man/man1"
	install -Dm600 bash.completion "$TERMUX_PREFIX/share/bash-completion/completions/gopass"
	install -Dm600 zsh.completion "$TERMUX_PREFIX/share/zsh/site-functions/_gopass"
	install -Dm600 fish.completion "$TERMUX_PREFIX/share/fish/vendor_completions.d/gopass.fish"
	install -Dm600 {README,CHANGELOG,ARCHITECTURE}.md -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	cd ./docs
	rm -f logo*.*
	cp --parents -r * -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
}
