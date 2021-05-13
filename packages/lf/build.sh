TERMUX_PKG_HOMEPAGE=https://github.com/gokcehan/lf
TERMUX_PKG_DESCRIPTION="Terminal file manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="27"
TERMUX_PKG_SRCURL=https://github.com/gokcehan/lf/archive/r$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cdd132e33387423ef9f9448e21d3f1e5c9a5319b34fdfb53cb5f49351ebac005
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_CONFFILES="etc/lf/lfrc"

termux_step_make() {
	termux_setup_golang
	export GOPATH="$TERMUX_PKG_BUILDDIR"
	mkdir -p "$GOPATH/src/github.com/gokcehan"
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH/src/github.com/gokcehan/lf"
	cd "$GOPATH/src/github.com/gokcehan/lf"
	go build -ldflags="-X main.gVersion=r$TERMUX_PKG_VERSION" -trimpath
}

termux_step_make_install() {
	cd "$GOPATH/src/github.com/gokcehan/lf"
	install -Dm755 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin" lf
	install -Dm644 -T etc/lfrc.example "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/lf/lfrc"
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/applications" lf.desktop
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/doc/lf" README.md
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1" lf.1
	# bash integration
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/profile.d" etc/lfcd.sh
	# csh integration
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/profile.d" etc/lf.csh etc/lfcd.csh
	# fish integration
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/fish/vendor_functions.d" etc/lfcd.fish
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/fish/vendor_completions.d" etc/lf.fish
	# vim integration
	install -Dm644 -t "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/vim/vimfiles/plugin" etc/lf.vim
	# zsh integration
	install -Dm644 -T etc/lfcd.sh "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/zsh/site-functions/lfcd"
	install -Dm644 -T etc/lf.zsh "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/zsh/site-functions/_lf"
}
