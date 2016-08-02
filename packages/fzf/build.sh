TERMUX_PKG_HOMEPAGE=https://github.com/junegunn/fzf
TERMUX_PKG_DESCRIPTION="Command-line fuzzy finder"
TERMUX_PKG_VERSION=0.13.3
TERMUX_PKG_SRCURL=https://github.com/junegunn/fzf/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=fzf-${TERMUX_PKG_VERSION}
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

	mkdir -p $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/{go-runewidth,go-shellwords}
	for file in runewidth.go runewidth_posix.go; do
		curl -o $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/go-runewidth/$file \
		        https://raw.githubusercontent.com/junegunn/go-runewidth/master/$file
	done
	for file in shellwords.go util_posix.go; do
		curl -o $GOPATH/src/github.com/junegunn/fzf/src/vendor/github.com/junegunn/go-shellwords/$file \
		        https://raw.githubusercontent.com/junegunn/go-shellwords/master/$file
	done

	cd $GOPATH/src/github.com/junegunn/fzf/src/fzf
	CGO_ENABLED=1 go build -a -ldflags="-extldflags=-pie" -o $TERMUX_PREFIX/bin/fzf

	# Install fzf-tmux, a bash script for launching fzf in a tmux pane:
	cp $TERMUX_PKG_SRCDIR/bin/fzf-tmux $TERMUX_PREFIX/bin

	# Install the fzf.1 man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/man/man1/fzf.1 $TERMUX_PREFIX/share/man/man1/

	# Install the vim plugin:
	mkdir -p $TERMUX_PREFIX/share/vim/vim74/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/vim/vim74/plugin/fzf.vim

	# Install the nvim plugin:
	mkdir -p $TERMUX_PREFIX/share/nvim/runtime/plugin
	cp $TERMUX_PKG_SRCDIR/plugin/fzf.vim $TERMUX_PREFIX/share/nvim/runtime/plugin/
}

termux_step_post_massage () {
	# Remove so that the vim build doesn't add it to vim-runtime:
	rm $TERMUX_PREFIX/share/vim/vim74/plugin/fzf.vim
}
