TERMUX_PKG_HOMEPAGE=https://github.com/junegunn/fzf
TERMUX_PKG_DESCRIPTION="Command-line fuzzy finder"
# Use git master until next release with https://github.com/junegunn/fzf/pull/768
TERMUX_PKG_VERSION=0.15.9.1
_COMMIT=847c512539f9909ae69a5067c1a64cb9bb485ea3
# TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/${TERMUX_PKG_VERSION}.tar.gz
# TERMUX_PKG_FOLDERNAME=fzf-${TERMUX_PKG_VERSION}
TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/$_COMMIT.zip
TERMUX_PKG_FOLDERNAME=fzf-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="bash, ncurses"

termux_step_make_install () {
	export GOPATH=$TERMUX_PKG_TMPDIR
	cd $GOPATH
	mkdir -p src/github.com/junegunn/fzf
	cp -Rf $TERMUX_PKG_SRCDIR/* src/github.com/junegunn/fzf

	termux_setup_golang
	export CGO_CFLAGS="-I$TERMUX_PREFIX/include -L$TERMUX_PREFIX/lib"
	export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"

	mkdir -p $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/{go-runewidth,go-shellwords,go-isatty}
	for file in runewidth.go runewidth_posix.go; do
		curl -o $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/go-runewidth/$file \
		        https://raw.githubusercontent.com/junegunn/go-runewidth/master/$file
	done
	for file in shellwords.go util_posix.go; do
		curl -o $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/go-shellwords/$file \
		        https://raw.githubusercontent.com/junegunn/go-shellwords/master/$file
	done
	curl -o $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/go-isatty/isatty_linux.go \
	        https://raw.githubusercontent.com/junegunn/go-isatty/master/isatty_linux.go

	cd $GOPATH/src/github.com/junegunn/fzf/src/fzf
	CGO_ENABLED=1 go build -a -ldflags="-extldflags=-pie" -o $TERMUX_PREFIX/bin/fzf

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	cp $TERMUX_PKG_SRCDIR/bin/fzf-tmux $TERMUX_PREFIX/bin

	# Install the fzf.1 man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/man/man1/fzf.1 $TERMUX_PREFIX/share/man/man1/

	# Install the vim plugin:
	mkdir -p $TERMUX_PREFIX/share/vim/vim80/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/vim/vim80/plugin/fzf.vim

	# Install bash, zsh and fish helper scripts:
	mkdir -p "$TERMUX_PREFIX/share/fzf"
	cp $TERMUX_PKG_SRCDIR/shell/* "$TERMUX_PREFIX/share/fzf"

	# Install the nvim plugin:
	mkdir -p $TERMUX_PREFIX/share/nvim/runtime/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/nvim/runtime/plugin/
}

termux_step_post_massage () {
	# Remove so that the vim build doesn't add it to vim-runtime:
	rm $TERMUX_PREFIX/share/vim/vim80/plugin/fzf.vim
}
